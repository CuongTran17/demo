package com.example.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.example.util.DatabaseConnection;
import org.json.JSONObject;
import org.json.JSONArray;

@WebServlet("/api/lesson-progress")
public class LessonProgressServlet extends HttpServlet {
    
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
            e.printStackTrace();
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
            if ("complete".equals(action)) {
                // Mark lesson as completed
                String sql = "INSERT INTO lesson_progress (user_id, course_id, lesson_id, completed, completed_at) " +
                           "VALUES (?, ?, ?, TRUE, NOW()) " +
                           "ON DUPLICATE KEY UPDATE completed = TRUE, completed_at = NOW()";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
                stmt.setString(2, courseId);
                stmt.setString(3, lessonId);
                stmt.executeUpdate();
                
                response.getWriter().write("{\"success\":true,\"message\":\"Lesson marked as completed\"}");
            } else if ("reset".equals(action)) {
                // Reset lesson progress
                String sql = "DELETE FROM lesson_progress WHERE user_id = ? AND course_id = ? AND lesson_id = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, userId);
                stmt.setString(2, courseId);
                stmt.setString(3, lessonId);
                stmt.executeUpdate();
                
                response.getWriter().write("{\"success\":true,\"message\":\"Lesson progress reset\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Invalid action\"}");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Database error: \" + e.getMessage()}");
        }
    }
}
