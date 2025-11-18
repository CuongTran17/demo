package com.example.servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.example.dao.CartDAO;
import com.example.dao.CourseDAO;
import com.example.dao.OrderDAO;
import com.example.model.Course;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private CourseDAO courseDAO;
    private OrderDAO orderDAO;
    private CartDAO cartDAO;
    
    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        orderDAO = new OrderDAO();
        cartDAO = new CartDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();
        Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
        Integer userId = (Integer) session.getAttribute("userId");
        
        // Check if user is logged in
        if (loggedIn == null || !loggedIn || userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=checkout");
            return;
        }
        
        // Load cart from database
        List<String> cartItems = cartDAO.getUserCart(userId);
        
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        // Get full course details for checkout page
        List<Course> cartCourses = new ArrayList<>();
        for (String courseId : cartItems) {
            try {
                Course course = courseDAO.getCourseById(courseId);
                if (course != null) {
                    cartCourses.add(course);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        request.setAttribute("cartCourses", cartCourses);
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();
        Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
        Integer userId = (Integer) session.getAttribute("userId");
        
        // Check if user is logged in
        if (loggedIn == null || !loggedIn || userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=checkout");
            return;
        }
        
        String paymentMethod = request.getParameter("paymentMethod");
        
        // Load cart from database instead of session
        List<String> cartItems = cartDAO.getUserCart(userId);
        
        if (cartItems == null || cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        
        try {
            // Get courses from cart
            List<Course> coursesToPurchase = new ArrayList<>();
            for (String courseId : cartItems) {
                Course course = courseDAO.getCourseById(courseId);
                if (course != null) {
                    coursesToPurchase.add(course);
                }
            }
            
            // Create order
            int orderId = orderDAO.createOrder(userId, coursesToPurchase, paymentMethod);
            
            if (orderId > 0) {
                // Clear cart after successful purchase - both database and session
                cartDAO.clearCart(userId);
                cartItems.clear();
                session.setAttribute("cart", cartItems);
                
                // Redirect to success page
                response.sendRedirect(request.getContextPath() + "/purchase-success.jsp?orderId=" + orderId);
            } else {
                // Redirect to error page
                request.setAttribute("error", "Có lỗi xảy ra khi xử lý đơn hàng. Vui lòng thử lại.");
                request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        }
    }
}
