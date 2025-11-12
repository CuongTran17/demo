package com.example.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.example.model.Course;
import com.example.util.DatabaseConnection;

public class CourseDAO {
    
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
            e.printStackTrace();
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
            e.printStackTrace();
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
            e.printStackTrace();
        }
        
        return null;
    }
    
    /**
     * Get user's purchased courses
     */
    public List<Course> getUserCourses(int userId) {
        List<Course> courses = new ArrayList<>();
        String sql = "SELECT c.* FROM courses c " +
                    "INNER JOIN user_courses uc ON c.course_id = uc.course_id " +
                    "WHERE uc.user_id = ? " +
                    "ORDER BY uc.purchased_at DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return courses;
    }
    
    /**
     * Check if user has purchased a course
     */
    public boolean hasUserPurchasedCourse(int userId, String courseId) {
        String sql = "SELECT COUNT(*) FROM user_courses WHERE user_id = ? AND course_id = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, courseId);
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
                case "free":
                    sql.append(" AND price = 0");
                    break;
                case "under500":
                    sql.append(" AND price > 0 AND price < 500000");
                    break;
                case "500to1000":
                    sql.append(" AND price >= 500000 AND price <= 1000000");
                    break;
                case "over1000":
                    sql.append(" AND price > 1000000");
                    break;
            }
        }
        
        // Sorting
        if (sortBy != null) {
            switch (sortBy) {
                case "price-asc":
                    sql.append(" ORDER BY price ASC");
                    break;
                case "price-desc":
                    sql.append(" ORDER BY price DESC");
                    break;
                case "popular":
                    sql.append(" ORDER BY students_count DESC");
                    break;
                case "newest":
                default:
                    sql.append(" ORDER BY created_at DESC");
                    break;
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
            e.printStackTrace();
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
