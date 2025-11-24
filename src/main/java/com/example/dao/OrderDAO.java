package com.example.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
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
     * Create a new order with note and custom status
     * @param userId User ID
     * @param courses List of courses to purchase
     * @param paymentMethod Payment method
     * @param orderNote Order note/reference
     * @param status Order status (completed, pending_payment, etc.)
     * @return Order ID if successful, -1 if failed
     */
    public int createOrderWithNote(int userId, List<Course> courses, String paymentMethod, String orderNote, String status) {
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
            
            // Insert order with note
            String orderSql = "INSERT INTO orders (user_id, total_amount, payment_method, status, order_note) " +
                             "VALUES (?, ?, ?, ?, ?)";
            orderStmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderStmt.setInt(1, userId);
            orderStmt.setBigDecimal(2, totalAmount);
            orderStmt.setString(3, paymentMethod);
            orderStmt.setString(4, status);
            orderStmt.setString(5, orderNote);
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
            
            for (Course course : courses) {
                // Add to order_items
                itemStmt.setInt(1, orderId);
                itemStmt.setString(2, course.getCourseId());
                itemStmt.setBigDecimal(3, course.getPrice());
                itemStmt.addBatch();
            }
            
            itemStmt.executeBatch();
            
            // Only add to course_progress if status is completed
            if ("completed".equals(status)) {
                String progressSql = "INSERT INTO course_progress (user_id, course_id, progress_percentage, status) " +
                                    "VALUES (?, ?, 0, 'in_progress') " +
                                    "ON DUPLICATE KEY UPDATE user_id = user_id";
                userCourseStmt = conn.prepareStatement(progressSql);
                
                for (Course course : courses) {
                    userCourseStmt.setInt(1, userId);
                    userCourseStmt.setString(2, course.getCourseId());
                    userCourseStmt.addBatch();
                }
                
                userCourseStmt.executeBatch();
            }
            
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
    
    /**
     * Update order status
     * @param orderId Order ID
     * @param status New status
     * @return true if successful, false otherwise
     */
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get all pending payment orders
     * @return List of pending orders with user info
     */
    public List<OrderInfo> getPendingPaymentOrders() {
        List<OrderInfo> orders = new ArrayList<>();
        String sql = "SELECT o.order_id, o.user_id, o.total_amount, o.payment_method, o.order_note, " +
                    "o.created_at, u.fullname, u.email, u.phone " +
                    "FROM orders o JOIN users u ON o.user_id = u.user_id " +
                    "WHERE o.status = 'pending_payment' ORDER BY o.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                OrderInfo order = new OrderInfo();
                order.orderId = rs.getInt("order_id");
                order.userId = rs.getInt("user_id");
                order.totalAmount = rs.getBigDecimal("total_amount");
                order.paymentMethod = rs.getString("payment_method");
                order.orderNote = rs.getString("order_note");
                order.createdAt = rs.getTimestamp("created_at");
                order.userFullname = rs.getString("fullname");
                order.userEmail = rs.getString("email");
                order.userPhone = rs.getString("phone");
                orders.add(order);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return orders;
    }
    
    /**
     * Inner class for order information
     */
    public static class OrderInfo {
        public int orderId;
        public int userId;
        public BigDecimal totalAmount;
        public String paymentMethod;
        public String orderNote;
        public java.sql.Timestamp createdAt;
        public String userFullname;
        public String userEmail;
        public String userPhone;
    }
}

