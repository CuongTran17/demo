package com.example.servlets;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Base64;
import java.util.UUID;

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

@WebServlet("/upload-course-image")
public class ImageUploadServlet extends HttpServlet {
    
    private static final Logger logger = LoggerFactory.getLogger(ImageUploadServlet.class);
    private static final String UPLOAD_DIR = "assets/img/course-uploads";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.getWriter().write("{\"status\": \"ImageUploadServlet is running\"}");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("=== ImageUploadServlet: doPost called ===");
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");
        
        System.out.println("User email: " + userEmail);
        
        // Check if user is a teacher
        if (userEmail == null || !userEmail.matches("teacher\\d*@ptit\\.edu\\.vn")) {
            System.out.println("Unauthorized access attempt");
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("{\"success\": false, \"message\": \"Unauthorized\"}");
            return;
        }
        
        try {
            // Read JSON body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            
            String jsonString = sb.toString();
            System.out.println("Received JSON length: " + jsonString.length());
            System.out.println("First 100 chars: " + jsonString.substring(0, Math.min(100, jsonString.length())));
            
            if (jsonString.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Empty request body\"}");
                return;
            }
            
            JSONObject json = new JSONObject(jsonString);
            
            if (!json.has("courseId") || !json.has("imageData") || !json.has("fileName")) {
                response.getWriter().write("{\"success\": false, \"message\": \"Missing required fields\"}");
                return;
            }
            
            String courseId = json.getString("courseId");
            String base64Image = json.getString("imageData");
            String fileName = json.getString("fileName");
            
            System.out.println("Course ID: " + courseId);
            System.out.println("File name: " + fileName);
            System.out.println("Base64 data length: " + base64Image.length());
            
            if (courseId.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"Course ID is required\"}");
                return;
            }
            
            if (base64Image.isEmpty()) {
                response.getWriter().write("{\"success\": false, \"message\": \"No image data\"}");
                return;
            }
            
            // Remove data:image/...;base64, prefix if present
            if (base64Image.contains(",")) {
                base64Image = base64Image.split(",")[1];
            }
            
            // Decode base64
            byte[] imageBytes = Base64.getDecoder().decode(base64Image);
            System.out.println("Decoded image size: " + imageBytes.length + " bytes");
            
            // Get file extension
            String fileExtension = ".jpg";
            if (fileName.contains(".")) {
                fileExtension = fileName.substring(fileName.lastIndexOf("."));
            }
            
            // Generate unique filename
            String newFileName = courseId + "_" + UUID.randomUUID().toString().substring(0, 8) + fileExtension;
            System.out.println("New filename: " + newFileName);
            
            // Get the real path to webapp directory
            String appPath = request.getServletContext().getRealPath("");
            String uploadPath = appPath + File.separator + UPLOAD_DIR;
            
            System.out.println("Upload path: " + uploadPath);
            
            // Create upload directory if it doesn't exist
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                boolean created = uploadDir.mkdirs();
                System.out.println("Upload directory created: " + created);
            }
            
            // Save file
            File outputFile = new File(uploadPath, newFileName);
            try (FileOutputStream fos = new FileOutputStream(outputFile)) {
                fos.write(imageBytes);
            }
            
            System.out.println("File saved to: " + outputFile.getAbsolutePath());
            
            // Update database with new thumbnail path
            String thumbnailUrl = request.getContextPath() + "/" + UPLOAD_DIR + "/" + newFileName;
            System.out.println("Thumbnail URL: " + thumbnailUrl);
            
            updateCourseThumbnail(courseId, thumbnailUrl);
            
            // Return success response
            JSONObject successResponse = new JSONObject();
            successResponse.put("success", true);
            successResponse.put("thumbnailUrl", thumbnailUrl);
            successResponse.put("message", "Image uploaded successfully");
            
            System.out.println("Sending response: " + successResponse.toString());
            response.getWriter().write(successResponse.toString());
            
        } catch (ServletException | IOException e) {
            logger.error("Servlet error: {}", e.getMessage(), e);
            
            // Return JSON error instead of throwing exception
            try {
                JSONObject errorResponse = new JSONObject();
                errorResponse.put("success", false);
                errorResponse.put("message", "Error: " + e.getClass().getSimpleName() + " - " + e.getMessage());
                errorResponse.put("error", e.toString());
                response.getWriter().write(errorResponse.toString());
            } catch (IOException ex) {
                // Fallback to plain JSON string
                logger.error("Error writing error response: {}", ex.getMessage(), ex);
            }
        } catch (Exception e) {
            logger.error("Unexpected error: {}", e.getMessage(), e);
            
            // Return JSON error instead of throwing exception
            try {
                JSONObject errorResponse = new JSONObject();
                errorResponse.put("success", false);
                errorResponse.put("message", "Error: " + e.getClass().getSimpleName() + " - " + e.getMessage());
                errorResponse.put("error", e.toString());
                response.getWriter().write(errorResponse.toString());
            } catch (IOException ex) {
                // Fallback to plain JSON string
                logger.error("Error writing error response: {}", ex.getMessage(), ex);
            }
        }
    }
    
    private void updateCourseThumbnail(String courseId, String thumbnailUrl) throws Exception {
        String sql = "UPDATE courses SET thumbnail = ? WHERE course_id = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, thumbnailUrl);
            stmt.setString(2, courseId);
            stmt.executeUpdate();
            
            System.out.println("Database updated for course: " + courseId);
        }
    }
}
