package com.example.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.example.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/api/lesson-progress")
public class LessonProgressServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(LessonProgressServlet.class);
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"Not logged in\"}");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        String courseId = request.getParameter("courseId");
        
        if (courseId == null || courseId.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Course ID required\"}");
            return;
        }
        
        try (Connection conn = DatabaseConnection.getNewConnection()) {
            String sql = "SELECT lesson_id FROM lesson_progress WHERE user_id = ? AND course_id = ? AND completed = TRUE";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setString(2, courseId);
            
            ResultSet rs = stmt.executeQuery();
            JSONArray completedLessons = new JSONArray();
            while (rs.next()) {
                completedLessons.put(rs.getString("lesson_id"));
            }
            
            JSONObject result = new JSONObject();
            result.put("completedLessons", completedLessons);
            response.getWriter().write(result.toString());
            
        } catch (SQLException e) {
            logger.error("Error getting lesson progress", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Database error\"}");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"Not logged in\"}");
            return;
        }
        
        Integer userId = (Integer) session.getAttribute("userId");
        String courseId = request.getParameter("courseId");
        String lessonId = request.getParameter("lessonId");
        String action = request.getParameter("action"); // "complete" or "reset"
        
        if (courseId == null || lessonId == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Course ID and Lesson ID required\"}");
            return;
        }
        
        try (Connection conn = DatabaseConnection.getNewConnection()) {
            switch (action != null ? action : "") {
                case "complete" -> {
                    // Mark lesson as completed
                    String sql = "INSERT INTO lesson_progress (user_id, course_id, lesson_id, completed, completed_at) " +
                               "VALUES (?, ?, ?, TRUE, NOW()) " +
                               "ON DUPLICATE KEY UPDATE completed = TRUE, completed_at = NOW()";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, userId);
                    stmt.setString(2, courseId);
                    stmt.setString(3, lessonId);
                    stmt.executeUpdate();
                    
                    // Update course progress percentage
                    updateCourseProgress(conn, userId, courseId);
                    
                    response.getWriter().write("{\"success\":true,\"message\":\"Lesson marked as completed\"}");
                }
                case "reset" -> {
                    // Reset lesson progress
                    String sql = "DELETE FROM lesson_progress WHERE user_id = ? AND course_id = ? AND lesson_id = ?";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, userId);
                    stmt.setString(2, courseId);
                    stmt.setString(3, lessonId);
                    stmt.executeUpdate();
                    
                    // Update course progress percentage
                    updateCourseProgress(conn, userId, courseId);
                    
                    response.getWriter().write("{\"success\":true,\"message\":\"Lesson progress reset\"}");
                }
                default -> {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\":\"Invalid action\"}");
                }
            }
            
            
        } catch (SQLException e) {
            logger.error("Error updating lesson progress", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Database error: \" + e.getMessage()}");
        }
    }
    
    /**
     * Update course progress percentage based on completed lessons
     * This will be reflected in teacher dashboard and student account page
     */
    private void updateCourseProgress(Connection conn, int userId, String courseId) throws SQLException {
        // Count total lessons for this course
        String countSql = "SELECT COUNT(*) as total FROM lessons WHERE course_id = ? AND is_active = TRUE";
        int totalLessons = 0;
        try (PreparedStatement stmt = conn.prepareStatement(countSql)) {
            stmt.setString(1, courseId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                totalLessons = rs.getInt("total");
            }
        }
        
        // If no lessons exist, set progress to 0
        if (totalLessons == 0) {
            totalLessons = 1; // Avoid division by zero
        }
        
        // Count completed lessons for this user and course
        String completedSql = "SELECT COUNT(*) as completed FROM lesson_progress " +
                             "WHERE user_id = ? AND course_id = ? AND completed = TRUE";
        int completedLessons = 0;
        try (PreparedStatement stmt = conn.prepareStatement(completedSql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, courseId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                completedLessons = rs.getInt("completed");
            }
        }
        
        // Calculate progress percentage
        int progressPercentage = (int) Math.round((completedLessons * 100.0) / totalLessons);
        
        // Calculate total hours from completed lessons
        double totalHours = calculateTotalHours(conn, userId, courseId);
        
        // Update or insert into course_progress
        String updateSql = "INSERT INTO course_progress (user_id, course_id, progress_percentage, total_hours, last_accessed, status) " +
                          "VALUES (?, ?, ?, ?, NOW(), ?) " +
                          "ON DUPLICATE KEY UPDATE " +
                          "progress_percentage = ?, total_hours = ?, last_accessed = NOW(), " +
                          "status = IF(? >= 100, 'completed', IF(? > 0, 'in_progress', 'not_started'))";
        
        try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
            String status = progressPercentage >= 100 ? "completed" : (progressPercentage > 0 ? "in_progress" : "not_started");
            
            stmt.setInt(1, userId);
            stmt.setString(2, courseId);
            stmt.setInt(3, progressPercentage);
            stmt.setDouble(4, totalHours);
            stmt.setString(5, status);
            stmt.setInt(6, progressPercentage);
            stmt.setDouble(7, totalHours);
            stmt.setInt(8, progressPercentage);
            stmt.setInt(9, progressPercentage);
            
            stmt.executeUpdate();
        }
    }
    
    /**
     * Calculate total hours from completed lessons
     * Parses duration format like "15:30" (15 minutes 30 seconds) or "1:05:30" (1 hour 5 minutes 30 seconds)
     */
    private double calculateTotalHours(Connection conn, int userId, String courseId) throws SQLException {
        String sql = "SELECT l.duration " +
                    "FROM lessons l " +
                    "JOIN lesson_progress lp ON l.lesson_id = CAST(lp.lesson_id AS UNSIGNED) " +
                    "WHERE lp.user_id = ? AND lp.course_id = ? AND lp.completed = TRUE";
        
        double totalHours = 0.0;
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, courseId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                String duration = rs.getString("duration");
                if (duration != null && !duration.isEmpty()) {
                    totalHours += parseDurationToHours(duration);
                }
            }
        }
        
        return Math.round(totalHours * 100.0) / 100.0; // Round to 2 decimal places
    }
    
    /**
     * Parse duration string to hours
     * Formats supported:
     * - "MM:SS" (e.g., "15:30" = 15 minutes 30 seconds = 0.26 hours)
     * - "HH:MM:SS" (e.g., "1:05:30" = 1 hour 5 minutes 30 seconds = 1.09 hours)
     */
    private double parseDurationToHours(String duration) {
        try {
            String[] parts = duration.split(":");
            
            if (parts.length == 2) {
                // MM:SS format
                int minutes = Integer.parseInt(parts[0].trim());
                int seconds = Integer.parseInt(parts[1].trim());
                return (minutes * 60 + seconds) / 3600.0;
                
            } else if (parts.length == 3) {
                // HH:MM:SS format
                int hours = Integer.parseInt(parts[0].trim());
                int minutes = Integer.parseInt(parts[1].trim());
                int seconds = Integer.parseInt(parts[2].trim());
                return hours + (minutes * 60 + seconds) / 3600.0;
            }
        } catch (NumberFormatException e) {
            // If parsing fails, return 0
            return 0.0;
        }
        
        return 0.0;
    }
}

