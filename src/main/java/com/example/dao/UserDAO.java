package com.example.dao;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.example.model.User;
import com.example.util.DatabaseConnection;

public class UserDAO {
    
    /**
     * Hash password using SHA-256
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
    
    /**
     * Register a new user
     */
    public boolean registerUser(User user) {
        String sql = "INSERT INTO users (email, phone, password_hash, fullname) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getPhone());
            stmt.setString(3, user.getPasswordHash());
            stmt.setString(4, user.getFullname());
            
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    user.setUserId(rs.getInt(1));
                }
                return true;
            }
            return false;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Login user by email or phone
     */
    public User loginUser(String emailOrPhone, String password) {
        String sql = "SELECT * FROM users WHERE (email = ? OR phone = ?) AND password_hash = ?";
        String hashedPassword = hashPassword(password);
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, emailOrPhone);
            stmt.setString(2, emailOrPhone);
            stmt.setString(3, hashedPassword);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setFullname(rs.getString("fullname"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));
                return user;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get user by ID
     */
    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setFullname(rs.getString("fullname"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));
                return user;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Check if email exists
     */
    public boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        
        System.out.println("UserDAO.emailExists: Checking email: " + email);
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("UserDAO.emailExists: Count for " + email + " = " + count);
                return count > 0;
            }
            
        } catch (SQLException e) {
            System.err.println("UserDAO.emailExists: Error checking email: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Check if phone exists
     */
    public boolean phoneExists(String phone) {
        String sql = "SELECT COUNT(*) FROM users WHERE phone = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, phone);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
    
    /**
     * Get user by email (for Remember Me cookie validation)
     */
    public User getUserByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setFullname(rs.getString("fullname"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                return user;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Update user profile
     */
    public boolean updateProfile(int userId, String fullname, String email, String phone) {
        String sql = "UPDATE users SET fullname = ?, email = ?, phone = ? WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, fullname);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setInt(4, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update user password
     */
    public boolean updatePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE users SET password_hash = ? WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newPasswordHash);
            stmt.setInt(2, userId);
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
