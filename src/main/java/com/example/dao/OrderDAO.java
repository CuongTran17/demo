package com.example.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

import com.example.model.Course;
import com.example.util.DatabaseConnection;

public class OrderDAO {
    
    /**
     * Create a new order and order items
     * @param userId User ID
     * @param courses List of courses to purchase
     * @param paymentMethod Payment method
     * @return Order ID if successful, -1 if failed
     */
    public int createOrder(int userId, List<Course> courses, String paymentMethod) {
        Connection conn = null;
        PreparedStatement orderStmt = null;
        PreparedStatement itemStmt = null;
        PreparedStatement userCourseStmt = null;
        ResultSet generatedKeys = null;
        
        try {
            conn = DatabaseConnection.getNewConnection();
            conn.setAutoCommit(false); // Start transaction
            
            // Calculate total amount
            BigDecimal totalAmount = BigDecimal.ZERO;
            for (Course course : courses) {
                totalAmount = totalAmount.add(course.getPrice());
            }
            
            // Insert order
            String orderSql = "INSERT INTO orders (user_id, total_amount, payment_method, status) " +
                             "VALUES (?, ?, ?, 'completed')";
            orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, userId);
            orderStmt.setBigDecimal(2, totalAmount);
            orderStmt.setString(3, paymentMethod);
            orderStmt.executeUpdate();
            
            // Get generated order ID
            generatedKeys = orderStmt.getGeneratedKeys();
            int orderId = -1;
            if (generatedKeys.next()) {
                orderId = generatedKeys.getInt(1);
            } else {
                throw new SQLException("Failed to get order ID");
            }
            
            // Insert order items
            String itemSql = "INSERT INTO order_items (order_id, course_id, price) VALUES (?, ?, ?)";
            itemStmt = conn.prepareStatement(itemSql);
            
            // Insert to course_progress table (correct table name)
            String progressSql = "INSERT INTO course_progress (user_id, course_id, progress_percentage, status) " +
                                "VALUES (?, ?, 0, 'in_progress') " +
                                "ON DUPLICATE KEY UPDATE user_id = user_id";
            userCourseStmt = conn.prepareStatement(progressSql);
            
            for (Course course : courses) {
                // Add to order_items
                itemStmt.setInt(1, orderId);
                itemStmt.setString(2, course.getCourseId());
                itemStmt.setBigDecimal(3, course.getPrice());
                itemStmt.addBatch();
                
                // Add to course_progress
                userCourseStmt.setInt(1, userId);
                userCourseStmt.setString(2, course.getCourseId());
                userCourseStmt.addBatch();
            }
            
            itemStmt.executeBatch();
            userCourseStmt.executeBatch();
            
            conn.commit(); // Commit transaction
            return orderId;
            
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback on error
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return -1;
        } finally {
            try {
                if (generatedKeys != null) generatedKeys.close();
                if (orderStmt != null) orderStmt.close();
                if (itemStmt != null) itemStmt.close();
                if (userCourseStmt != null) userCourseStmt.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Get user's order history
     */
    public ResultSet getUserOrders(int userId) {
        try {
            Connection conn = DatabaseConnection.getNewConnection();
            String sql = "SELECT o.*, COUNT(oi.order_item_id) as item_count " +
                        "FROM orders o " +
                        "LEFT JOIN order_items oi ON o.order_id = oi.order_id " +
                        "WHERE o.user_id = ? " +
                        "GROUP BY o.order_id " +
                        "ORDER BY o.created_at DESC";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            return stmt.executeQuery();
            
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Get list of purchased course IDs by user
     */
    public List<String> getPurchasedCoursesByUser(int userId) {
        List<String> purchasedCourses = new java.util.ArrayList<>();
        String sql = "SELECT DISTINCT oi.course_id " +
                     "FROM orders o " +
                     "INNER JOIN order_items oi ON o.order_id = oi.order_id " +
                     "WHERE o.user_id = ? AND o.status = 'completed'";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                purchasedCourses.add(rs.getString("course_id"));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return purchasedCourses;
    }
}

