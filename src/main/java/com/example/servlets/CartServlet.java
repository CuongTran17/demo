package com.example.servlets;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.example.dao.CartDAO;
import com.example.dao.CourseDAO;
import com.example.model.Course;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(CartServlet.class);
    private CourseDAO courseDAO;
    private CartDAO cartDAO;
    
    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        cartDAO = new CartDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
        
        List<String> cartItems;
        
        // If user is logged in, load cart from database
        if (loggedIn != null && loggedIn && userId != null) {
            cartItems = cartDAO.getUserCart(userId);
            // Sync with session
            session.setAttribute("cart", cartItems);
        } else {
            // For guest users, use session cart
            @SuppressWarnings("unchecked")
            List<String> sessionCart = (List<String>) session.getAttribute("cart");
            cartItems = sessionCart != null ? sessionCart : new ArrayList<>();
        }
        
        // Get full course details for items in cart
        List<Course> cartCourses = new ArrayList<>();
        for (String courseId : cartItems) {
            try {
                Course course = courseDAO.getCourseById(courseId);
                if (course != null) {
                    cartCourses.add(course);
                }
            } catch (Exception e) {
                logger.error("Error getting course details for cart", e);
            }
        }
        
        request.setAttribute("cartCourses", cartCourses);
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        String courseId = request.getParameter("courseId");
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
        
        switch (action) {
            case "add" -> {
                // Check if user is logged in
                if (loggedIn == null || !loggedIn || userId == null) {
                    // User not logged in - require login
                    response.setContentType("application/json; charset=UTF-8");
                    response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng đăng nhập để thêm vào giỏ hàng\", \"requireLogin\": true}");
                    return;
                }
                
                // Check if user has already purchased this course
                if (courseDAO.hasUserPurchasedCourse(userId, courseId)) {
                    response.setContentType("application/json; charset=UTF-8");
                    response.getWriter().write("{\"success\": false, \"message\": \"Bạn đã mua khóa học này rồi. Vui lòng kiểm tra trong 'Khóa học của tôi'\"}");
                    return;
                }
                
                // User is logged in - add to cart in database
                boolean success = cartDAO.addToCart(userId, courseId);
                
                if (success) {
                    // Update session cart
                    List<String> cartItems = cartDAO.getUserCart(userId);
                    session.setAttribute("cart", cartItems);
                }
                
                response.setContentType("application/json; charset=UTF-8");
                if (success) {
                    response.getWriter().write("{\"success\": true, \"message\": \"Đã thêm vào giỏ hàng\"}");
                } else {
                    response.getWriter().write("{\"success\": false, \"message\": \"Khóa học đã có trong giỏ hàng\"}");
                }
            }
            case "remove" -> {
                // Remove from cart
                if (loggedIn != null && loggedIn && userId != null) {
                    cartDAO.removeFromCart(userId, courseId);
                }
                
                // Also remove from session
                @SuppressWarnings("unchecked")
                List<String> cartItems = (List<String>) session.getAttribute("cart");
                if (cartItems != null) {
                    cartItems.remove(courseId);
                    session.setAttribute("cart", cartItems);
                }
                
                response.sendRedirect(request.getContextPath() + "/cart");
            }
            case "clear" -> {
                // Clear cart
                if (loggedIn != null && loggedIn && userId != null) {
                    cartDAO.clearCart(userId);
                }
                
                // Also clear session
                session.setAttribute("cart", new ArrayList<String>());
                response.sendRedirect(request.getContextPath() + "/cart");
            }
        }
    }
}
