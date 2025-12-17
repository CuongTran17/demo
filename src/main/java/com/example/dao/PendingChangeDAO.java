package com.example.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.example.model.PendingChange;
import com.example.util.DatabaseConnection;

public class PendingChangeDAO {
    
    /**
     * Tạo một pending change mới
     */
    public int createPendingChange(int teacherId, String changeType, String targetId, String changeData) throws SQLException {
        String sql = "INSERT INTO pending_changes (requested_by, change_type, target_id, change_data, table_name, status) " +
                     "VALUES (?, ?, ?, ?, ?, 'pending')";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, teacherId);
            stmt.setString(2, changeType);
            stmt.setString(3, targetId);
            stmt.setString(4, changeData);
            // Determine table_name from targetId or changeType
            String tableName = changeType.contains("course") || targetId.contains("-") ? "courses" : "lessons";
            stmt.setString(5, tableName);
            
            stmt.executeUpdate();
            
            ResultSet rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1;
    }
    
    /**
     * Lấy tất cả pending changes (chờ duyệt)
     */
    public List<PendingChange> getAllPendingChanges() throws SQLException {
        List<PendingChange> changes = new ArrayList<>();
        String sql = "SELECT * FROM pending_changes_view WHERE status = 'pending' ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                PendingChange change = new PendingChange();
                change.setChangeId(rs.getInt("change_id"));
                change.setTeacherId(rs.getInt("teacher_id"));
                change.setTeacherName(rs.getString("teacher_name"));
                change.setTeacherEmail(rs.getString("teacher_email"));
                change.setChangeType(rs.getString("change_type"));
                change.setTargetId(rs.getString("target_id"));
                change.setChangeData(rs.getString("change_data"));
                change.setStatus(rs.getString("status"));
                change.setCreatedAt(rs.getTimestamp("created_at"));
                changes.add(change);
            }
        }
        return changes;
    }
    
    /**
     * Lấy lịch sử tất cả các thay đổi đã được duyệt hoặc từ chối
     */
    public List<PendingChange> getReviewedChanges() throws SQLException {
        List<PendingChange> changes = new ArrayList<>();
        String sql = "SELECT * FROM pending_changes_view WHERE status IN ('approved', 'rejected') ORDER BY reviewed_at DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                PendingChange change = new PendingChange();
                change.setChangeId(rs.getInt("change_id"));
                change.setTeacherId(rs.getInt("teacher_id"));
                change.setTeacherName(rs.getString("teacher_name"));
                change.setTeacherEmail(rs.getString("teacher_email"));
                change.setChangeType(rs.getString("change_type"));
                change.setTargetId(rs.getString("target_id"));
                change.setChangeData(rs.getString("change_data"));
                change.setStatus(rs.getString("status"));
                change.setCreatedAt(rs.getTimestamp("created_at"));
                change.setReviewedAt(rs.getTimestamp("reviewed_at"));
                change.setReviewedBy(rs.getInt("reviewed_by"));
                change.setReviewerName(rs.getString("reviewer_name"));
                change.setReviewNote(rs.getString("review_note"));
                changes.add(change);
            }
        }
        return changes;
    }
    
    /**
     * Lấy pending changes của một giáo viên
     */
    public List<PendingChange> getPendingChangesByTeacher(int teacherId) throws SQLException {
        List<PendingChange> changes = new ArrayList<>();
        String sql = "SELECT * FROM pending_changes_view WHERE teacher_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, teacherId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                PendingChange change = new PendingChange();
                change.setChangeId(rs.getInt("change_id"));
                change.setTeacherId(rs.getInt("teacher_id"));
                change.setTeacherName(rs.getString("teacher_name"));
                change.setTeacherEmail(rs.getString("teacher_email"));
                change.setChangeType(rs.getString("change_type"));
                change.setTargetId(rs.getString("target_id"));
                change.setChangeData(rs.getString("change_data"));
                change.setStatus(rs.getString("status"));
                change.setCreatedAt(rs.getTimestamp("created_at"));
                change.setReviewedAt(rs.getTimestamp("reviewed_at"));
                change.setReviewedBy(rs.getInt("reviewed_by"));
                change.setReviewerName(rs.getString("reviewer_name"));
                change.setReviewNote(rs.getString("review_note"));
                changes.add(change);
            }
        }
        return changes;
    }
    
    /**
     * Lấy thông tin một pending change
     */
    public PendingChange getPendingChangeById(int changeId) throws SQLException {
        String sql = "SELECT * FROM pending_changes_view WHERE change_id = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, changeId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                PendingChange change = new PendingChange();
                change.setChangeId(rs.getInt("change_id"));
                change.setTeacherId(rs.getInt("teacher_id"));
                change.setTeacherName(rs.getString("teacher_name"));
                change.setTeacherEmail(rs.getString("teacher_email"));
                change.setChangeType(rs.getString("change_type"));
                change.setTargetId(rs.getString("target_id"));
                change.setChangeData(rs.getString("change_data"));
                change.setStatus(rs.getString("status"));
                change.setCreatedAt(rs.getTimestamp("created_at"));
                change.setReviewedAt(rs.getTimestamp("reviewed_at"));
                change.setReviewedBy(rs.getInt("reviewed_by"));
                change.setReviewerName(rs.getString("reviewer_name"));
                change.setReviewNote(rs.getString("review_note"));
                return change;
            }
        }
        return null;
    }
    
    /**
     * Approve một pending change
     */
    public boolean approvePendingChange(int changeId, int adminId, String note) throws SQLException {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getNewConnection();
            conn.setAutoCommit(false);
            
            // Get change info
            PendingChange change = getPendingChangeById(changeId);
            if (change == null || !"pending".equals(change.getStatus())) {
                conn.rollback();
                return false;
            }
            
            // Apply the change based on change_type
            applyChange(conn, change);
            
            // Update pending_changes status
            String sql = "UPDATE pending_changes SET status = 'approved', reviewed_by = ?, " +
                        "reviewed_at = NOW(), review_note = ? WHERE change_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, adminId);
                stmt.setString(2, note);
                stmt.setInt(3, changeId);
                stmt.executeUpdate();
            }
            
            conn.commit();
            return true;
            
        } catch (Exception e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
    
    /**
     * Reject một pending change
     */
    public boolean rejectPendingChange(int changeId, int adminId, String note) throws SQLException {
        String sql = "UPDATE pending_changes SET status = 'rejected', reviewed_by = ?, " +
                     "reviewed_at = NOW(), review_note = ? WHERE change_id = ? AND status = 'pending'";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, adminId);
            stmt.setString(2, note);
            stmt.setInt(3, changeId);
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Apply change vào database
     */
    private void applyChange(Connection conn, PendingChange change) throws SQLException {
        String changeType = change.getChangeType();
        String targetId = change.getTargetId();
        String changeData = change.getChangeData();
        
        // Parse JSON và apply change dựa vào changeType
        // Sử dụng JSON parsing đơn giản (có thể cần thư viện JSON như Gson)
        
        if ("course_create".equals(changeType)) {
            // Parse changeData JSON và insert vào courses table
            // Ví dụ: {"course_id": "python-basics", "course_name": "Python Cơ bản", "category": "python", "description": "Khóa học...", "price": 1200000}
            String courseId = extractJsonValue(changeData, "course_id");
            String courseName = extractJsonValue(changeData, "course_name");
            String category = extractJsonValue(changeData, "category");
            String description = extractJsonValue(changeData, "description");
            String priceStr = extractJsonValue(changeData, "price");
            
            if (courseId != null && courseName != null && category != null && priceStr != null) {
                // Insert course
                String sql1 = "INSERT INTO courses (course_id, course_name, category, description, price, created_at) VALUES (?, ?, ?, ?, ?, NOW())";
                try (PreparedStatement stmt = conn.prepareStatement(sql1)) {
                    stmt.setString(1, courseId);
                    stmt.setString(2, courseName);
                    stmt.setString(3, category);
                    stmt.setString(4, description != null ? description : "");
                    stmt.setBigDecimal(5, new BigDecimal(priceStr));
                    stmt.executeUpdate();
                }
                
                // Assign teacher to course
                String sql2 = "INSERT INTO teacher_courses (teacher_id, course_id) VALUES (?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql2)) {
                    stmt.setInt(1, change.getTeacherId());
                    stmt.setString(2, courseId);
                    stmt.executeUpdate();
                }
            }
            
        } else if ("course_update".equals(changeType)) {
            // Parse changeData JSON và update courses table
            // Ví dụ: {"course_name": "New Name", "description": "New Desc", "price": 100.0, "image_url": "path/to/image.jpg", "image_filename": "path/to/image.jpg"}
            String courseName = extractJsonValue(changeData, "course_name");
            String description = extractJsonValue(changeData, "description");
            String priceStr = extractJsonValue(changeData, "price");
            String imageUrl = extractJsonValue(changeData, "image_url");
            String imageFilename = extractJsonValue(changeData, "image_filename");
            
            // Debug logging
            System.out.println("=== DEBUG course_update ===");
            System.out.println("changeData: " + changeData);
            System.out.println("courseName: [" + courseName + "]");
            System.out.println("description: [" + description + "]");
            System.out.println("priceStr: [" + priceStr + "]");
            System.out.println("imageUrl: [" + imageUrl + "]");
            System.out.println("imageFilename: [" + imageFilename + "]");
            
            StringBuilder sql = new StringBuilder("UPDATE courses SET ");
            List<String> updates = new ArrayList<>();
            List<Object> params = new ArrayList<>();
            
            if (courseName != null && !courseName.trim().isEmpty()) {
                updates.add("course_name = ?");
                params.add(courseName);
                System.out.println("Added courseName param");
            }
            if (description != null && !description.trim().isEmpty()) {
                updates.add("description = ?");
                params.add(description);
                System.out.println("Added description param");
            }
            if (priceStr != null && !priceStr.trim().isEmpty()) {
                try {
                    updates.add("price = ?");
                    params.add(new BigDecimal(priceStr));
                    System.out.println("Added price param");
                } catch (NumberFormatException e) {
                    System.out.println("Skipped invalid price");
                }
            }
            if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                updates.add("image_url = ?");
                params.add(imageUrl);
                System.out.println("Added imageUrl param");
            }
            // Handle image_filename (for uploaded images)
            if (imageFilename != null && !imageFilename.trim().isEmpty()) {
                updates.add("thumbnail = ?");
                params.add(imageFilename);
                System.out.println("Added imageFilename param for thumbnail");
            }
            
            if (!updates.isEmpty()) {
                sql.append(String.join(", ", updates));
                sql.append(", last_modified_by = ?, last_modified_at = NOW() WHERE course_id = ?");
                
                System.out.println("Final SQL: " + sql.toString());
                System.out.println("Total params in list: " + params.size());
                System.out.println("Total placeholders expected: " + (params.size() + 2));
                
                try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
                    int paramIndex = 1;
                    for (Object param : params) {
                        System.out.println("Setting param " + paramIndex + ": " + param);
                        stmt.setObject(paramIndex++, param);
                    }
                    System.out.println("Setting param " + paramIndex + " (teacherId): " + change.getTeacherId());
                    stmt.setInt(paramIndex++, change.getTeacherId());
                    System.out.println("Setting param " + paramIndex + " (targetId): " + targetId);
                    stmt.setString(paramIndex, targetId);
                    stmt.executeUpdate();
                    System.out.println("Update successful!");
                }
            }
            
        } else if ("course_delete".equals(changeType)) {
            // Delete course from both courses and teacher_courses tables
            // First delete from courses table
            String sql1 = "DELETE FROM courses WHERE course_id = ? AND course_id IN " +
                         "(SELECT course_id FROM teacher_courses WHERE teacher_id = ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql1)) {
                stmt.setString(1, targetId);
                stmt.setInt(2, change.getTeacherId());
                stmt.executeUpdate();
            }
            
            // Then delete from teacher_courses table
            String sql2 = "DELETE FROM teacher_courses WHERE course_id = ? AND teacher_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql2)) {
                stmt.setString(1, targetId);
                stmt.setInt(2, change.getTeacherId());
                stmt.executeUpdate();
            }
            
        } else if ("lesson_create".equals(changeType)) {
            // Parse changeData JSON và insert vào lessons table
            // Ví dụ: {"course_id": "course123", "lesson_title": "Title", "lesson_content": "Content", "lesson_order": 1, "section_id": 1, "video_url": "url", "duration": "10:00"}
            String courseId = extractJsonValue(changeData, "course_id");
            String lessonTitle = extractJsonValue(changeData, "lesson_title");
            String lessonContent = extractJsonValue(changeData, "lesson_content");
            String orderStr = extractJsonValue(changeData, "lesson_order");
            String sectionIdStr = extractJsonValue(changeData, "section_id");
            String videoUrl = extractJsonValue(changeData, "video_url");
            String duration = extractJsonValue(changeData, "duration");
            
            if (courseId != null && lessonTitle != null) {
                String sql = "INSERT INTO lessons (course_id, lesson_title, lesson_content, lesson_order, section_id, video_url, duration, created_at) " +
                           "VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, courseId);
                    stmt.setString(2, lessonTitle);
                    stmt.setString(3, lessonContent != null ? lessonContent : "");
                    stmt.setInt(4, orderStr != null ? Integer.parseInt(orderStr) : 1);
                    stmt.setInt(5, sectionIdStr != null ? Integer.parseInt(sectionIdStr) : 1);
                    stmt.setString(6, videoUrl != null ? videoUrl : "");
                    stmt.setString(7, duration != null ? duration : "");
                    stmt.executeUpdate();
                }
            }
            
        } else if ("lesson_update".equals(changeType)) {
            // Parse changeData JSON và update lessons table
            String lessonTitle = extractJsonValue(changeData, "lesson_title");
            String lessonContent = extractJsonValue(changeData, "lesson_content");
            String orderStr = extractJsonValue(changeData, "lesson_order");
            
            if (lessonTitle != null || lessonContent != null || orderStr != null) {
                StringBuilder sql = new StringBuilder("UPDATE lessons SET ");
                List<String> updates = new ArrayList<>();
                List<Object> params = new ArrayList<>();
                
                if (lessonTitle != null) {
                    updates.add("lesson_title = ?");
                    params.add(lessonTitle);
                }
                if (lessonContent != null) {
                    updates.add("lesson_content = ?");
                    params.add(lessonContent);
                }
                if (orderStr != null) {
                    updates.add("lesson_order = ?");
                    params.add(Integer.valueOf(orderStr));
                }
                
                sql.append(String.join(", ", updates));
                sql.append(", last_modified_by = ?, last_modified_at = NOW() WHERE lesson_id = ?");
                
                try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
                    for (int i = 0; i < params.size(); i++) {
                        stmt.setObject(i + 1, params.get(i));
                    }
                    stmt.setInt(params.size() + 1, change.getTeacherId());
                    stmt.setString(params.size() + 2, targetId);
                    stmt.executeUpdate();
                }
            }
            
        } else if ("lesson_delete".equals(changeType)) {
            // Delete lesson
            String sql = "DELETE FROM lessons WHERE lesson_id = ? AND course_id IN " +
                        "(SELECT course_id FROM teacher_courses WHERE teacher_id = ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, targetId);
                stmt.setInt(2, change.getTeacherId());
                stmt.executeUpdate();
            }
        }
    }
    
    /**
     * Extract value từ JSON string đơn giản (không dùng thư viện)
     */
    private String extractJsonValue(String json, String key) {
        try {
            if (json == null || json.trim().isEmpty() || "{}".equals(json.trim())) {
                return null;
            }
            
            // Tìm key trong JSON
            String keyPattern = "\"" + key + "\":";
            int keyIndex = json.indexOf(keyPattern);
            if (keyIndex == -1) return null;
            
            // Tìm vị trí sau dấu :
            int colonIndex = keyIndex + keyPattern.length();
            
            // Bỏ qua whitespace sau dấu :
            while (colonIndex < json.length() && Character.isWhitespace(json.charAt(colonIndex))) {
                colonIndex++;
            }
            
            if (colonIndex >= json.length()) return null;
            
            int valueStart, valueEnd;
            
            // Kiểm tra xem giá trị có bắt đầu bằng dấu " không
            if (json.charAt(colonIndex) == '"') {
                // String value - tìm dấu " đóng
                valueStart = colonIndex + 1;
                valueEnd = json.indexOf('"', valueStart);
            } else {
                // Number or boolean - tìm dấu , hoặc }
                valueStart = colonIndex;
                valueEnd = json.indexOf(',', valueStart);
                if (valueEnd == -1) {
                    valueEnd = json.indexOf('}', valueStart);
                }
            }
            
            if (valueEnd == -1) return null;
            
            String value = json.substring(valueStart, valueEnd).trim();
            // Trả về null nếu giá trị rỗng hoặc "null"
            return (value.isEmpty() || "null".equalsIgnoreCase(value)) ? null : value;
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * Đếm số pending changes
     */
    public int countPendingChanges() throws SQLException {
        String sql = "SELECT COUNT(*) as count FROM pending_changes WHERE status = 'pending'";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("count");
            }
        }
        return 0;
    }
}
