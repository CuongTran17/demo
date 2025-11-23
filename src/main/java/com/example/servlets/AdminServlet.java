package com.example.servlets;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.example.dao.PendingChangeDAO;
import com.example.dao.UserDAO;
import com.example.model.PendingChange;
import com.example.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    
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
        
        // Check if this is the admin account
        if (!"admin@ptit.edu.vn".equals(userEmail)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Chỉ tài khoản quản trị viên mới có thể truy cập trang này");
            return;
        }
        
        try {
            // Get statistics
            AdminStats stats = getAdminStats();
            request.setAttribute("stats", stats);
            
            // Get all users
            List<UserInfo> users = getAllUsers();
            request.setAttribute("users", users);
            
            // Get all teachers
            List<TeacherInfo> teachers = getAllTeachers();
            request.setAttribute("teachers", teachers);
            
            // Get all courses
            List<CourseInfo> courses = getAllCourses();
            request.setAttribute("courses", courses);
            
            // Get pending changes
            PendingChangeDAO pendingDAO = new PendingChangeDAO();
            List<PendingChange> pendingChanges = pendingDAO.getAllPendingChanges();
            request.setAttribute("pendingChanges", pendingChanges);
            request.setAttribute("pendingCount", pendingChanges.size());
            
            // Get reviewed changes history
            List<PendingChange> reviewedChanges = pendingDAO.getReviewedChanges();
            request.setAttribute("reviewedChanges", reviewedChanges);
            
            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi hệ thống: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        String userEmail = (String) session.getAttribute("userEmail");
        
        if (userId == null || !"admin@ptit.edu.vn".equals(userEmail)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        try {
            switch (action) {
                case "createTeacher":
                    createTeacher(request);
                    break;
                case "updateUser":
                    updateUser(request);
                    break;
                case "deleteUser":
                    deleteUser(request);
                    break;
                case "assignCourse":
                    assignCourseToTeacher(request);
                    break;
                case "removeCourse":
                    removeCourseFromTeacher(request);
                    break;
                case "approveChange":
                    approveChange(request, userId);
                    break;
                case "rejectChange":
                    rejectChange(request, userId);
                    break;
            }
            
            response.sendRedirect(request.getContextPath() + "/admin");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý: " + e.getMessage());
        }
    }
    
    private AdminStats getAdminStats() {
        AdminStats stats = new AdminStats();
        
        try (Connection conn = DatabaseConnection.getNewConnection()) {
            
            // Total users
            String sql1 = "SELECT COUNT(*) as total FROM users";
            try (PreparedStatement stmt = conn.prepareStatement(sql1)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.totalUsers = rs.getInt("total");
                }
            }
            
            // Total teachers
            String sql2 = "SELECT COUNT(DISTINCT teacher_id) as total FROM teacher_courses";
            try (PreparedStatement stmt = conn.prepareStatement(sql2)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.totalTeachers = rs.getInt("total");
                }
            }
            
            // Total courses
            String sql3 = "SELECT COUNT(*) as total FROM courses";
            try (PreparedStatement stmt = conn.prepareStatement(sql3)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.totalCourses = rs.getInt("total");
                }
            }
            
            // Total orders
            String sql4 = "SELECT COUNT(*) as total FROM orders WHERE status = 'completed'";
            try (PreparedStatement stmt = conn.prepareStatement(sql4)) {
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    stats.totalOrders = rs.getInt("total");
                }
            }
            
            // Total revenue
            String sql5 = "SELECT COALESCE(SUM(total_amount), 0) as total FROM orders WHERE status = 'completed'";
            try (PreparedStatement stmt = conn.prepareStatement(sql5)) {
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
    
    private List<UserInfo> getAllUsers() {
        List<UserInfo> users = new ArrayList<>();
        String sql = "SELECT user_id, email, phone, fullname, created_at FROM users ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                UserInfo user = new UserInfo();
                user.userId = rs.getInt("user_id");
                user.email = rs.getString("email");
                user.phone = rs.getString("phone");
                user.fullname = rs.getString("fullname");
                user.createdAt = rs.getTimestamp("created_at");
                users.add(user);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return users;
    }
    
    private List<TeacherInfo> getAllTeachers() {
        List<TeacherInfo> teachers = new ArrayList<>();
        String sql = "SELECT DISTINCT u.user_id, u.email, u.fullname, " +
                     "(SELECT COUNT(*) FROM teacher_courses tc WHERE tc.teacher_id = u.user_id) as course_count " +
                     "FROM users u " +
                     "JOIN teacher_courses tc ON u.user_id = tc.teacher_id " +
                     "ORDER BY u.fullname";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                TeacherInfo teacher = new TeacherInfo();
                teacher.userId = rs.getInt("user_id");
                teacher.email = rs.getString("email");
                teacher.fullname = rs.getString("fullname");
                teacher.courseCount = rs.getInt("course_count");
                teachers.add(teacher);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return teachers;
    }
    
    private List<CourseInfo> getAllCourses() {
        List<CourseInfo> courses = new ArrayList<>();
        String sql = "SELECT c.*, " +
                     "(SELECT COUNT(*) FROM order_items oi JOIN orders o ON oi.order_id = o.order_id " +
                     " WHERE oi.course_id = c.course_id AND o.status = 'completed') as enrolled_count " +
                     "FROM courses c ORDER BY c.course_name";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                CourseInfo course = new CourseInfo();
                course.courseId = rs.getString("course_id");
                course.courseName = rs.getString("course_name");
                course.category = rs.getString("category");
                course.price = rs.getBigDecimal("price");
                course.enrolledCount = rs.getInt("enrolled_count");
                courses.add(course);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return courses;
    }
    
    private void createTeacher(HttpServletRequest request) throws SQLException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        
        try (Connection conn = DatabaseConnection.getNewConnection()) {
            // Check if email already exists
            String checkSql = "SELECT user_id FROM users WHERE email = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, email);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    throw new SQLException("Email đã tồn tại trong hệ thống");
                }
            }
            
            // Insert new teacher account
            String sql = "INSERT INTO users (email, password_hash, fullname, phone) VALUES (?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, email);
                stmt.setString(2, UserDAO.hashPassword(password)); // Hash the password
                stmt.setString(3, fullname);
                stmt.setString(4, phone);
                stmt.executeUpdate();
            }
        }
    }
    
    private void updateUser(HttpServletRequest request) throws SQLException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        
        String sql = "UPDATE users SET fullname = ?, phone = ? WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, fullname);
            stmt.setString(2, phone);
            stmt.setInt(3, userId);
            stmt.executeUpdate();
        }
    }
    
    private void deleteUser(HttpServletRequest request) throws SQLException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        
        // Don't allow deleting admin account
        try (Connection conn = DatabaseConnection.getNewConnection()) {
            String checkSql = "SELECT email FROM users WHERE user_id = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, userId);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && "admin@ptit.edu.vn".equals(rs.getString("email"))) {
                    throw new SQLException("Không thể xóa tài khoản admin");
                }
            }
            
            String sql = "DELETE FROM users WHERE user_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, userId);
                stmt.executeUpdate();
            }
        }
    }
    
    private void assignCourseToTeacher(HttpServletRequest request) throws SQLException {
        int teacherId = Integer.parseInt(request.getParameter("teacherId"));
        String courseId = request.getParameter("courseId");
        
        String sql = "INSERT INTO teacher_courses (teacher_id, course_id) VALUES (?, ?)";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, teacherId);
            stmt.setString(2, courseId);
            stmt.executeUpdate();
        }
    }
    
    private void removeCourseFromTeacher(HttpServletRequest request) throws SQLException {
        int teacherId = Integer.parseInt(request.getParameter("teacherId"));
        String courseId = request.getParameter("courseId");
        
        String sql = "DELETE FROM teacher_courses WHERE teacher_id = ? AND course_id = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, teacherId);
            stmt.setString(2, courseId);
            stmt.executeUpdate();
        }
    }
    
    private void approveChange(HttpServletRequest request, int adminId) throws SQLException {
        int changeId = Integer.parseInt(request.getParameter("changeId"));
        String note = request.getParameter("note");
        
        PendingChangeDAO pendingDAO = new PendingChangeDAO();
        pendingDAO.approvePendingChange(changeId, adminId, note);
    }
    
    private void rejectChange(HttpServletRequest request, int adminId) throws SQLException {
        int changeId = Integer.parseInt(request.getParameter("changeId"));
        String note = request.getParameter("note");
        
        PendingChangeDAO pendingDAO = new PendingChangeDAO();
        pendingDAO.rejectPendingChange(changeId, adminId, note);
    }
    
    // Inner classes for data models
    public static class AdminStats {
        public int totalUsers;
        public int totalTeachers;
        public int totalCourses;
        public int totalOrders;
        public BigDecimal totalRevenue = BigDecimal.ZERO;
    }
    
    public static class UserInfo {
        public int userId;
        public String email;
        public String phone;
        public String fullname;
        public Timestamp createdAt;
    }
    
    public static class TeacherInfo {
        public int userId;
        public String email;
        public String fullname;
        public int courseCount;
    }
    
    public static class CourseInfo {
        public String courseId;
        public String courseName;
        public String category;
        public BigDecimal price;
        public int enrolledCount;
    }
}
