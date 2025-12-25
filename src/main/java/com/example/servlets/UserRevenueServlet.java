package com.example.servlets;

import java.io.IOException;
import java.math.BigDecimal;
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

@WebServlet("/admin/user-revenue")
public class UserRevenueServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(UserRevenueServlet.class);
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
        String userEmail = (String) session.getAttribute("userEmail");
        
        if (userId == null || loggedIn == null || !loggedIn) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Check if this is the admin account
        if (!"admin@ptit.edu.vn".equals(userEmail)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ tài khoản quản trị viên mới có thể truy cập trang này");
            return;
        }
        
        try {
            // Get user revenue details
            List<UserRevenueDetail> userRevenues = getUserRevenueDetails();
            request.setAttribute("userRevenues", userRevenues);
            
            // Calculate total statistics
            BigDecimal totalRevenue = BigDecimal.ZERO;
            int totalOrders = 0;
            int totalUsers = userRevenues.size();
            
            for (UserRevenueDetail ur : userRevenues) {
                totalRevenue = totalRevenue.add(ur.totalSpent);
                totalOrders += ur.orderCount;
            }
            
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("totalOrders", totalOrders);
            request.setAttribute("totalUsers", totalUsers);
            
            request.getRequestDispatcher("/user-revenue-detail.jsp").forward(request, response);
            
        } catch (Exception e) {
            logger.error("Error loading user revenue details", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải dữ liệu doanh thu");
        }
    }
    
    private List<UserRevenueDetail> getUserRevenueDetails() throws SQLException {
        List<UserRevenueDetail> list = new ArrayList<>();
        
        String sql = "SELECT " +
                    "    u.user_id, " +
                    "    u.email, " +
                    "    u.fullname, " +
                    "    u.phone, " +
                    "    COUNT(DISTINCT o.order_id) as order_count, " +
                    "    SUM(o.total_amount) as total_spent, " +
                    "    MAX(o.created_at) as last_purchase " +
                    "FROM users u " +
                    "INNER JOIN orders o ON u.user_id = o.user_id " +
                    "GROUP BY u.user_id, u.email, u.fullname, u.phone " +
                    "ORDER BY total_spent DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                UserRevenueDetail detail = new UserRevenueDetail();
                detail.userId = rs.getInt("user_id");
                detail.email = rs.getString("email");
                detail.fullname = rs.getString("fullname");
                detail.phone = rs.getString("phone");
                detail.orderCount = rs.getInt("order_count");
                detail.totalSpent = rs.getBigDecimal("total_spent");
                detail.lastPurchase = rs.getTimestamp("last_purchase");
                
                // Get purchased courses for this user
                detail.purchasedCourses = getPurchasedCourses(detail.userId);
                
                list.add(detail);
            }
        }
        
        return list;
    }
    
    private List<CourseOrderDetail> getPurchasedCourses(int userId) throws SQLException {
        List<CourseOrderDetail> courses = new ArrayList<>();
        
        String sql = "SELECT " +
                    "    c.course_id, " +
                    "    c.course_name, " +
                    "    c.category, " +
                    "    oi.price, " +
                    "    o.created_at as purchase_date, " +
                    "    o.order_id, " +
                    "    o.status " +
                    "FROM orders o " +
                    "INNER JOIN order_items oi ON o.order_id = oi.order_id " +
                    "INNER JOIN courses c ON oi.course_id = c.course_id " +
                    "WHERE o.user_id = ? " +
                    "ORDER BY o.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CourseOrderDetail course = new CourseOrderDetail();
                    course.courseId = rs.getString("course_id");
                    course.courseName = rs.getString("course_name");
                    course.category = rs.getString("category");
                    course.price = rs.getBigDecimal("price");
                    course.purchaseDate = rs.getTimestamp("purchase_date");
                    course.orderId = rs.getInt("order_id");
                    course.status = rs.getString("status");
                    
                    courses.add(course);
                }
            }
        }
        
        return courses;
    }
    
    // Inner class for user revenue detail
    public static class UserRevenueDetail {
        public int userId;
        public String email;
        public String fullname;
        public String phone;
        public int orderCount;
        public BigDecimal totalSpent;
        public Timestamp lastPurchase;
        public List<CourseOrderDetail> purchasedCourses;
    }
    
    // Inner class for course order detail
    public static class CourseOrderDetail {
        public String courseId;
        public String courseName;
        public String category;
        public BigDecimal price;
        public Timestamp purchaseDate;
        public int orderId;
        public String status;
    }
}
