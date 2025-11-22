package com.example.servlets;

import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

import org.json.JSONObject;

import com.example.dao.PendingChangeDAO;
import com.example.model.PendingChange;
import com.example.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/teacher")
public class TeacherServlet extends HttpServlet {
    
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
        
        // Check if this is a teacher account
        if (userEmail == null || !userEmail.matches("teacher\\d*@ptit\\.edu\\.vn")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ tài khoản giáo viên mới có thể truy cập trang này");
            return;
        }
        
        try {
            // Get teacher's courses
            List<TeacherCourse> courses = getTeacherCourses(userId);
            request.setAttribute("teacherCourses", courses);
            
            // Get students enrolled in teacher's courses
            List<StudentInfo> students = getEnrolledStudents(userId);
            request.setAttribute("students", students);
            
            // Get course statistics
            CourseStats stats = getCourseStats(userId);
            request.setAttribute("stats", stats);
            
            // Get pending changes for this teacher
            PendingChangeDAO pendingDAO = new PendingChangeDAO();
            List<PendingChange> pendingChanges = pendingDAO.getPendingChangesByTeacher(userId);
            request.setAttribute("pendingChanges", pendingChanges);
            
            request.getRequestDispatcher("/teacher-dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("TeacherServlet doPost called - URI: " + request.getRequestURI() + ", Content-Type: " + request.getContentType());
        
        response.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String userEmail = (String) session.getAttribute("userEmail");
        
        if (action == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Missing action parameter\"}");
            return;
        }
        
        if (userId == null || userEmail == null || !userEmail.matches("teacher\\d*@ptit\\.edu\\.vn")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            switch (action) {
                case "createCourse":
                    createCourse(request, userId);
                    break;
                case "updateCourse":
                    updateCourse(request, userId);
                    session.setAttribute("successMessage", "Yêu cầu cập nhật khóa học đã được gửi cho admin duyệt!");
                    break;
                case "uploadImage":
                    uploadCourseImage(request, response);
                    return; // Don't redirect, return JSON
                case "deleteCourse":
                    deleteCourse(request, userId);
                    break;
                case "createLesson":
                    createLesson(request, userId);
                    session.setAttribute("successMessage", "Yêu cầu tạo bài học đã được gửi cho admin duyệt!");
                    break;
                case "updateLesson":
                    updateLesson(request, userId);
                    session.setAttribute("successMessage", "Yêu cầu cập nhật bài học đã được gửi cho admin duyệt!");
                    break;
                case "deleteLesson":
                    deleteLesson(request, userId);
                    session.setAttribute("successMessage", "Yêu cầu xóa bài học đã được gửi cho admin duyệt!");
                    break;
            }
            
            response.sendRedirect(request.getContextPath() + "/teacher");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý: " + e.getMessage());
        }
    }
    

    
    private List<TeacherCourse> getTeacherCourses(int teacherId) {
        List<TeacherCourse> courses = new ArrayList<>();
        String sql = "SELECT c.*, tc.created_at as assigned_at, " +
                     "(SELECT COUNT(*) FROM order_items oi JOIN orders o ON oi.order_id = o.order_id " +
                     " WHERE oi.course_id = c.course_id AND o.status = 'completed') as enrolled_count " +
                     "FROM courses c " +
                     "JOIN teacher_courses tc ON c.course_id = tc.course_id " +
                     "WHERE tc.teacher_id = ? " +
                     "ORDER BY tc.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, teacherId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                TeacherCourse course = new TeacherCourse();
                course.courseId = rs.getString("course_id");
                course.courseName = rs.getString("course_name");
                course.category = rs.getString("category");
                course.description = rs.getString("description");
                course.price = rs.getBigDecimal("price");
                course.enrolledCount = rs.getInt("enrolled_count");
                course.assignedAt = rs.getTimestamp("assigned_at");
                course.thumbnail = rs.getString("thumbnail");
                courses.add(course);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return courses;
    }
    
    private List<StudentInfo> getEnrolledStudents(int teacherId) {
        List<StudentInfo> students = new ArrayList<>();
        String sql = "SELECT DISTINCT u.user_id, u.fullname, u.email, o.created_at as enrolled_date, " +
                     "c.course_name, " +
                     "COALESCE(cp.progress_percentage, 0) as progress " +
                     "FROM users u " +
                     "JOIN orders o ON u.user_id = o.user_id " +
                     "JOIN order_items oi ON o.order_id = oi.order_id " +
                     "JOIN courses c ON oi.course_id = c.course_id " +
                     "JOIN teacher_courses tc ON c.course_id = tc.course_id " +
                     "LEFT JOIN course_progress cp ON u.user_id = cp.user_id AND c.course_id = cp.course_id " +
                     "WHERE tc.teacher_id = ? AND o.status = 'completed' " +
                     "ORDER BY o.created_at DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, teacherId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                StudentInfo student = new StudentInfo();
                student.userId = rs.getInt("user_id");
                student.fullname = rs.getString("fullname");
                student.email = rs.getString("email");
                student.courseName = rs.getString("course_name");
                student.enrolledDate = rs.getTimestamp("enrolled_date");
                student.progress = rs.getInt("progress");
                students.add(student);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return students;
    }
    
    private CourseStats getCourseStats(int teacherId) {
        CourseStats stats = new CourseStats();
        
        // Get total courses
        String sql1 = "SELECT COUNT(*) as total FROM teacher_courses WHERE teacher_id = ?";
        
        // Get total students
        String sql2 = "SELECT COUNT(DISTINCT u.user_id) as total " +
                      "FROM users u " +
                      "JOIN orders o ON u.user_id = o.user_id " +
                      "JOIN order_items oi ON o.order_id = oi.order_id " +
                      "JOIN teacher_courses tc ON oi.course_id = tc.course_id " +
                      "WHERE tc.teacher_id = ? AND o.status = 'completed'";
        
        // Get total revenue
        String sql3 = "SELECT COALESCE(SUM(oi.price), 0) as total " +
                      "FROM order_items oi " +
                      "JOIN orders o ON oi.order_id = o.order_id " +
                      "JOIN teacher_courses tc ON oi.course_id = tc.course_id " +
                      "WHERE tc.teacher_id = ? AND o.status = 'completed'";
        
        try (Connection conn = DatabaseConnection.getNewConnection()) {
            
            // Total courses
            try (PreparedStatement stmt = conn.prepareStatement(sql1)) {
                stmt.setInt(1, teacherId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.totalCourses = rs.getInt("total");
                }
            }
            
            // Total students
            try (PreparedStatement stmt = conn.prepareStatement(sql2)) {
                stmt.setInt(1, teacherId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.totalStudents = rs.getInt("total");
                }
            }
            
            // Total revenue
            try (PreparedStatement stmt = conn.prepareStatement(sql3)) {
                stmt.setInt(1, teacherId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.totalRevenue = rs.getBigDecimal("total");
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return stats;
    }
    
    private void createCourse(HttpServletRequest request, int teacherId) throws SQLException {
        String courseId = request.getParameter("courseId");
        String courseName = request.getParameter("courseName");
        String category = request.getParameter("category");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        
        BigDecimal price = new BigDecimal(priceStr);
        
        Connection conn = DatabaseConnection.getNewConnection();
        conn.setAutoCommit(false);
        
        try {
            // Insert course
            String sql1 = "INSERT INTO courses (course_id, course_name, category, description, price) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql1)) {
                stmt.setString(1, courseId);
                stmt.setString(2, courseName);
                stmt.setString(3, category);
                stmt.setString(4, description);
                stmt.setBigDecimal(5, price);
                stmt.executeUpdate();
            }
            
            // Assign teacher to course
            String sql2 = "INSERT INTO teacher_courses (teacher_id, course_id) VALUES (?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql2)) {
                stmt.setInt(1, teacherId);
                stmt.setString(2, courseId);
                stmt.executeUpdate();
            }
            
            conn.commit();
        } catch (SQLException e) {
            conn.rollback();
            throw e;
        } finally {
            conn.close();
        }
    }
    
    private void updateCourse(HttpServletRequest request, int teacherId) throws SQLException {
        String courseId = request.getParameter("courseId");
        String courseName = request.getParameter("courseName");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        
        // Tạo JSON data cho pending change
        StringBuilder changeData = new StringBuilder();
        changeData.append("{");
        if (courseName != null && !courseName.trim().isEmpty()) {
            changeData.append("\"course_name\":\"").append(courseName.replace("\"", "\\\"")).append("\"");
        }
        if (description != null && !description.trim().isEmpty()) {
            if (changeData.length() > 1) changeData.append(",");
            changeData.append("\"description\":\"").append(description.replace("\"", "\\\"")).append("\"");
        }
        if (priceStr != null && !priceStr.trim().isEmpty()) {
            if (changeData.length() > 1) changeData.append(",");
            changeData.append("\"price\":").append(priceStr);
        }
        changeData.append("}");
        
        // Tạo pending change thay vì update trực tiếp
        PendingChangeDAO pendingDAO = new PendingChangeDAO();
        pendingDAO.createPendingChange(teacherId, "course_update", courseId, changeData.toString());
    }
    
    private void deleteCourse(HttpServletRequest request, int teacherId) throws SQLException {
        String courseId = request.getParameter("courseId");
        
        String sql = "DELETE FROM courses WHERE course_id = ? AND course_id IN " +
                     "(SELECT course_id FROM teacher_courses WHERE teacher_id = ?)";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, courseId);
            stmt.setInt(2, teacherId);
            
            stmt.executeUpdate();
        }
    }
    
    private void createLesson(HttpServletRequest request, int teacherId) throws SQLException {
        String courseId = request.getParameter("courseId");
        String lessonTitle = request.getParameter("lessonTitle");
        String lessonContent = request.getParameter("lessonContent");
        String videoUrl = request.getParameter("videoUrl");
        String duration = request.getParameter("duration");
        String sectionId = request.getParameter("sectionId");
        String lessonOrder = request.getParameter("lessonOrder");
        
        // Tạo JSON data cho pending change
        StringBuilder changeData = new StringBuilder();
        changeData.append("{\"course_id\":\"").append(courseId).append("\"");
        if (lessonTitle != null && !lessonTitle.trim().isEmpty()) {
            changeData.append(",\"lesson_title\":\"").append(lessonTitle.replace("\"", "\\\"")).append("\"");
        }
        if (lessonContent != null && !lessonContent.trim().isEmpty()) {
            changeData.append(",\"lesson_content\":\"").append(lessonContent.replace("\"", "\\\"")).append("\"");
        }
        if (videoUrl != null && !videoUrl.trim().isEmpty()) {
            changeData.append(",\"video_url\":\"").append(videoUrl.replace("\"", "\\\"")).append("\"");
        }
        if (duration != null && !duration.trim().isEmpty()) {
            changeData.append(",\"duration\":\"").append(duration).append("\"");
        }
        if (sectionId != null && !sectionId.trim().isEmpty()) {
            changeData.append(",\"section_id\":").append(sectionId);
        }
        if (lessonOrder != null && !lessonOrder.trim().isEmpty()) {
            changeData.append(",\"lesson_order\":").append(lessonOrder);
        }
        changeData.append("}");
        
        // Tạo pending change thay vì insert trực tiếp
        PendingChangeDAO pendingDAO = new PendingChangeDAO();
        pendingDAO.createPendingChange(teacherId, "lesson_create", courseId, changeData.toString());
    }
    
    private void updateLesson(HttpServletRequest request, int teacherId) throws SQLException {
        String lessonId = request.getParameter("lessonId");
        String lessonTitle = request.getParameter("lessonTitle");
        String lessonContent = request.getParameter("lessonContent");
        String videoUrl = request.getParameter("videoUrl");
        String duration = request.getParameter("duration");
        String sectionId = request.getParameter("sectionId");
        String lessonOrder = request.getParameter("lessonOrder");
        
        // Tạo JSON data cho pending change
        StringBuilder changeData = new StringBuilder();
        changeData.append("{");
        if (lessonTitle != null && !lessonTitle.trim().isEmpty()) {
            changeData.append("\"lesson_title\":\"").append(lessonTitle.replace("\"", "\\\"")).append("\"");
        }
        if (lessonContent != null && !lessonContent.trim().isEmpty()) {
            if (changeData.length() > 1) changeData.append(",");
            changeData.append("\"lesson_content\":\"").append(lessonContent.replace("\"", "\\\"")).append("\"");
        }
        if (videoUrl != null && !videoUrl.trim().isEmpty()) {
            if (changeData.length() > 1) changeData.append(",");
            changeData.append("\"video_url\":\"").append(videoUrl.replace("\"", "\\\"")).append("\"");
        }
        if (duration != null && !duration.trim().isEmpty()) {
            if (changeData.length() > 1) changeData.append(",");
            changeData.append("\"duration\":\"").append(duration).append("\"");
        }
        if (sectionId != null && !sectionId.trim().isEmpty()) {
            if (changeData.length() > 1) changeData.append(",");
            changeData.append("\"section_id\":").append(sectionId);
        }
        if (lessonOrder != null && !lessonOrder.trim().isEmpty()) {
            if (changeData.length() > 1) changeData.append(",");
            changeData.append("\"lesson_order\":").append(lessonOrder);
        }
        changeData.append("}");
        
        // Tạo pending change thay vì update trực tiếp
        PendingChangeDAO pendingDAO = new PendingChangeDAO();
        pendingDAO.createPendingChange(teacherId, "lesson_update", lessonId, changeData.toString());
    }
    
    private void deleteLesson(HttpServletRequest request, int teacherId) throws SQLException {
        String lessonId = request.getParameter("lessonId");
        
        // Tạo pending change thay vì delete trực tiếp
        PendingChangeDAO pendingDAO = new PendingChangeDAO();
        pendingDAO.createPendingChange(teacherId, "lesson_delete", lessonId, "{}");
    }
    
    // Inner classes for data transfer
    public static class TeacherCourse {
        public String courseId;
        public String courseName;
        public String category;
        public String description;
        public BigDecimal price;
        public int enrolledCount;
        public Timestamp assignedAt;
        public String thumbnail;
    }
    
    public static class StudentInfo {
        public int userId;
        public String fullname;
        public String email;
        public String courseName;
        public Timestamp enrolledDate;
        public int progress;
    }
    
    public static class CourseStats {
        public int totalCourses = 0;
        public int totalStudents = 0;
        public BigDecimal totalRevenue = BigDecimal.ZERO;
    }
    
    private void uploadCourseImage(HttpServletRequest request, HttpServletResponse response) 
            throws Exception {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");
        
        try {
            String imageUrl = request.getParameter("imageUrl");
            String courseId = request.getParameter("courseId");
            
            System.out.println("uploadCourseImage called - courseId: " + courseId + ", imageUrl length: " + (imageUrl != null ? imageUrl.length() : "null"));
            
            if (courseId == null || imageUrl == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Missing parameters\"}");
                return;
            }
            
            // Decode base64 and save as file
            String base64Data = imageUrl;
            if (base64Data.startsWith("data:image/")) {
                // Remove data URL prefix if present
                int commaIndex = base64Data.indexOf(",");
                if (commaIndex > 0) {
                    base64Data = base64Data.substring(commaIndex + 1);
                }
            }
            
            // Generate unique filename
            String fileName = "course_" + courseId + "_" + System.currentTimeMillis() + ".jpg";
            String relativePath = "assets/img/course-uploads/" + fileName;
            
            // Decode image once
            byte[] imageBytes = Base64.getDecoder().decode(base64Data);
            
            // Save to source directory (so it persists after rebuild)
            String sourcePath = "C:/Users/Lenovo/Downloads/demo/src/main/webapp/" + relativePath;
            java.io.File sourceDir = new java.io.File(sourcePath).getParentFile();
            if (!sourceDir.exists()) {
                sourceDir.mkdirs();
            }
            try (FileOutputStream fos = new FileOutputStream(sourcePath)) {
                fos.write(imageBytes);
            }
            
            // Also save to deployed directory (for immediate display)
            String deployedPath = getServletContext().getRealPath("/") + relativePath;
            java.io.File deployedDir = new java.io.File(deployedPath).getParentFile();
            if (!deployedDir.exists()) {
                deployedDir.mkdirs();
            }
            try (FileOutputStream fos = new FileOutputStream(deployedPath)) {
                fos.write(imageBytes);
            }
            
            // Update database with file path
            String sql = "UPDATE courses SET thumbnail = ? WHERE course_id = ?";
            try (Connection conn = DatabaseConnection.getNewConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                
                stmt.setString(1, relativePath);
                stmt.setString(2, courseId);
                stmt.executeUpdate();
            }
            
            // Return success response
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("success", true);
            jsonResponse.put("message", "Image uploaded successfully");
            jsonResponse.put("thumbnailUrl", relativePath);
            response.getWriter().write(jsonResponse.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
}