package com.example.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.example.model.Course;
import com.example.util.DatabaseConnection;

public class CourseDAO {
    private static final Logger logger = LoggerFactory.getLogger(CourseDAO.class);
    
    /**
     * Get all courses
     */
    public List<Course> getAllCourses() {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM courses ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
            
        } catch (SQLException e) {
            logger.error("Error getting all courses", e);
        }
        
        return courses;
    }
    
    /**
     * Get courses by category
     */
    public List<Course> getCoursesByCategory(String category) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT * FROM courses WHERE category = ? ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, category);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
            
        } catch (SQLException e) {
            logger.error("Error getting courses by category", e);
        }
        
        return courses;
    }
    
    /**
     * Get course by ID
     */
    public Course getCourseById(String courseId) {
        String sql = "SELECT * FROM courses WHERE course_id = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, courseId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToCourse(rs);
            }
            
        } catch (SQLException e) {
            logger.error("Error getting course by ID", e);
        }
        
        return null;
    }
    
    /**
     * Get user's purchased courses
     */
    public List<Course> getUserCourses(int userId) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT DISTINCT c.* FROM courses c " +
                    "INNER JOIN order_items oi ON c.course_id = oi.course_id " +
                    "INNER JOIN orders o ON oi.order_id = o.order_id " +
                    "WHERE o.user_id = ? AND o.status = 'completed' " +
                    "ORDER BY o.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
            
        } catch (SQLException e) {
            logger.error("Error getting user courses", e);
        }
        
        return courses;
    }
    
    /**
     * Check if user has purchased a course
     */
    public boolean hasUserPurchasedCourse(int userId, String courseId) {
        String sql = "SELECT COUNT(*) FROM orders o " +
                     "INNER JOIN order_items oi ON o.order_id = oi.order_id " +
                     "WHERE o.user_id = ? AND oi.course_id = ? AND o.status = 'completed'";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, courseId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            logger.error("Error checking if user purchased course", e);
        }
        
        return false;
    }
    
    /**
     * Search courses with filters
     */
    public List<Course> searchCourses(String keyword, String category, String priceRange, String sortBy) {
        List<Course> courses = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM courses WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        // Keyword search
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (course_name LIKE ? OR description LIKE ?)");
            String searchPattern = "%" + keyword + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        // Category filter
        if (category != null && !category.equals("all")) {
            sql.append(" AND category = ?");
            params.add(category);
        }
        
        // Price filter
        if (priceRange != null && !priceRange.equals("all")) {
            switch (priceRange) {
                case "free" -> sql.append(" AND price = 0");
                case "under500" -> sql.append(" AND price > 0 AND price < 500000");
                case "500to1000" -> sql.append(" AND price >= 500000 AND price <= 1000000");
                case "over1000" -> sql.append(" AND price > 1000000");
            }
        }
        
        // Sorting
        if (sortBy != null) {
            switch (sortBy) {
                case "price-asc" -> sql.append(" ORDER BY price ASC");
                case "price-desc" -> sql.append(" ORDER BY price DESC");
                case "popular" -> sql.append(" ORDER BY students_count DESC");
                case "newest" -> sql.append(" ORDER BY created_at DESC");
                default -> sql.append(" ORDER BY created_at DESC");
            }
        } else {
            sql.append(" ORDER BY created_at DESC");
        }
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
            
        } catch (SQLException e) {
            logger.error("Error searching courses", e);
        }
        
        return courses;
    }
    
    /**
     * Map ResultSet to Course object
     */
    private Course mapResultSetToCourse(ResultSet rs) throws SQLException {
        Course course = new Course();
        course.setCourseId(rs.getString("course_id"));
        course.setCourseName(rs.getString("course_name"));
        course.setCategory(rs.getString("category"));
        course.setDescription(rs.getString("description"));
        course.setPrice(rs.getBigDecimal("price"));
        course.setOldPrice(rs.getBigDecimal("old_price"));
        course.setDuration(rs.getString("duration"));
        course.setStudentsCount(rs.getInt("students_count"));
        course.setLevel(rs.getString("level"));
        course.setThumbnail(rs.getString("thumbnail"));
        course.setNew(rs.getBoolean("is_new"));
        course.setDiscountPercentage(rs.getInt("discount_percentage"));
        course.setCreatedAt(rs.getTimestamp("created_at"));
        return course;
    }
}
