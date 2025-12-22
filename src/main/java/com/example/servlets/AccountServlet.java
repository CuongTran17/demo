package com.example.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.example.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/account")
public class AccountServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(AccountServlet.class);
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
        
        if (userId == null || loggedIn == null || !loggedIn) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            // Get purchased courses from orders table
            List<OrderInfo> orders = getPurchasedCourses(userId);
            request.setAttribute("orders", orders);
            
            // Get learning progress stats
            ProgressStats stats = getProgressStats(userId);
            request.setAttribute("stats", stats);
            
            request.getRequestDispatcher("/account.jsp").forward(request, response);
            
        } catch (ServletException e) {
            logger.error("Servlet error in account request", e);
            response.sendRedirect(request.getContextPath() + "/account.jsp");
        } catch (IOException e) {
            logger.error("IO error in account request", e);
            response.sendRedirect(request.getContextPath() + "/account.jsp");
        } catch (Exception e) {
            logger.error("Unexpected error in account request", e);
            response.sendRedirect(request.getContextPath() + "/account.jsp");
        }
    }
    
    private List<OrderInfo> getPurchasedCourses(int userId) {
        List<OrderInfo> orders = new ArrayList<>();
        String sql = "SELECT oi.course_id, c.course_name, oi.price, o.created_at, o.status " +
                     "FROM orders o " +
                     "JOIN order_items oi ON o.order_id = oi.order_id " +
                     "JOIN courses c ON oi.course_id = c.course_id " +
                     "WHERE o.user_id = ? " +
                     "ORDER BY o.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                OrderInfo order = new OrderInfo();
                order.orderId = 0; // Not using order_id in display
                order.courseId = rs.getString("course_id");
                order.courseName = rs.getString("course_name");
                order.purchaseDate = rs.getTimestamp("created_at");
                order.totalPrice = rs.getBigDecimal("price");
                order.orderStatus = rs.getString("status");
                orders.add(order);
            }
            
        } catch (SQLException e) {
            logger.error("Error getting purchased courses", e);
        }
        
        return orders;
    }
    
    private ProgressStats getProgressStats(int userId) {
        ProgressStats stats = new ProgressStats();
        String sql = "SELECT COUNT(*) as total_courses, " +
                     "SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as completed_courses, " +
                     "SUM(total_hours) as total_hours " +
                     "FROM course_progress WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                stats.totalCourses = rs.getInt("total_courses");
                stats.completedCourses = rs.getInt("completed_courses");
                stats.totalHours = rs.getDouble("total_hours");
                System.out.println("DEBUG AccountServlet - User " + userId + ": total_courses=" + stats.totalCourses + ", completed=" + stats.completedCourses + ", hours=" + stats.totalHours);
            }
            
        } catch (SQLException e) {
            logger.error("Error getting progress stats", e);
        }
        
        return stats;
    }
    
    // Inner classes for data transfer
    public static class OrderInfo {
        public int orderId;
        public String courseId;
        public String courseName;
        public Timestamp purchaseDate;
        public java.math.BigDecimal totalPrice;
        public String orderStatus;
    }
    
    public static class ProgressStats {
        public int totalCourses;
        public int completedCourses;
        public double totalHours;
    }
}
