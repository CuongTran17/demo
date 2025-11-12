package com.example.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.example.util.DatabaseConnection;

public class CartDAO {
    
    /**
     * Add course to user's cart in database
     */
    public boolean addToCart(int userId, String courseId) {
        // First check if already exists
        String checkSql = "SELECT COUNT(*) FROM cart WHERE user_id = ? AND course_id = ?";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
            
            checkStmt.setInt(1, userId);
            checkStmt.setString(2, courseId);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                // Already exists, return false
                return false;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        
        // Not exists, insert new
        String insertSql = "INSERT INTO cart (user_id, course_id) VALUES (?, ?)";
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(insertSql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, courseId);
            
            int rows = stmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Remove course from user's cart
     */
    public boolean removeFromCart(int userId, String courseId) {
        String sql = "DELETE FROM cart WHERE user_id = ? AND course_id = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, courseId);
            
            int rows = stmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get all course IDs in user's cart
     */
    public List<String> getUserCart(int userId) {
        List<String> cartItems = new ArrayList<>();
        String sql = "SELECT course_id FROM cart WHERE user_id = ? ORDER BY added_at DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                cartItems.add(rs.getString("course_id"));
            }
            rs.close();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return cartItems;
    }
    
    /**
     * Clear user's cart (e.g., after successful purchase)
     */
    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            int rows = stmt.executeUpdate();
            return rows >= 0; // Return true even if cart was already empty
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Check if course is in user's cart
     */
    public boolean isInCart(int userId, String courseId) {
        String sql = "SELECT COUNT(*) as count FROM cart WHERE user_id = ? AND course_id = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, courseId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
            rs.close();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get cart item count for a user
     */
    public int getCartCount(int userId) {
        String sql = "SELECT COUNT(*) as count FROM cart WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
            rs.close();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
}
