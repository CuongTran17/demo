package com.example.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.example.dao.UserDAO;
import com.example.util.DatabaseConnection;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/account-lock")
public class AccountLockServlet extends HttpServlet {
    private UserDAO userDAO;
    private Gson gson;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
        gson = new Gson();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"Chưa đăng nhập\"}");
            return;
        }
        
        int currentUserId = (int) session.getAttribute("userId");
        String userEmail = (String) session.getAttribute("userEmail");
        String action = request.getParameter("action");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            switch (action) {
                case "lock":
                    // Admin locks account directly
                    if (!"admin@ptit.edu.vn".equals(userEmail)) {
                        result.put("success", false);
                        result.put("message", "Chỉ admin mới có quyền khóa tài khoản trực tiếp");
                        break;
                    }
                    
                    int targetUserId = Integer.parseInt(request.getParameter("userId"));
                    String reason = request.getParameter("reason");
                    
                    // Check if account is already locked
                    com.example.model.User targetUser = userDAO.getUserById(targetUserId);
                    if (targetUser != null && targetUser.isLocked()) {
                        com.example.model.User lockedByUser = userDAO.getUserById(targetUser.getLockedBy());
                        String lockedByName = lockedByUser != null ? lockedByUser.getFullname() : "Không rõ";
                        String lockedDate = targetUser.getLockedAt() != null ? targetUser.getLockedAt().toString() : "Không rõ";
                        result.put("success", false);
                        result.put("message", "Tài khoản này đã bị khóa!\n" +
                                              "Bởi: " + lockedByName + "\n" +
                                              "Lý do: " + targetUser.getLockedReason() + "\n" +
                                              "Ngày giờ: " + lockedDate);
                        break;
                    }
                    
                    if (userDAO.lockUserAccount(targetUserId, reason, currentUserId)) {
                        result.put("success", true);
                        result.put("message", "Đã khóa tài khoản thành công");
                    } else {
                        result.put("success", false);
                        result.put("message", "Không thể khóa tài khoản");
                    }
                    break;
                    
                case "unlock":
                    // Admin unlocks account
                    if (!"admin@ptit.edu.vn".equals(userEmail)) {
                        result.put("success", false);
                        result.put("message", "Chỉ admin mới có quyền mở khóa tài khoản");
                        break;
                    }
                    
                    targetUserId = Integer.parseInt(request.getParameter("userId"));
                    
                    if (userDAO.unlockUserAccount(targetUserId)) {
                        result.put("success", true);
                        result.put("message", "Đã mở khóa tài khoản thành công");
                    } else {
                        result.put("success", false);
                        result.put("message", "Không thể mở khóa tài khoản");
                    }
                    break;
                    
                case "request":
                    // Teacher requests to lock a student account
                    if (!userEmail.matches("teacher\\d*@ptit\\.edu\\.vn")) {
                        result.put("success", false);
                        result.put("message", "Chỉ giáo viên mới có thể yêu cầu khóa tài khoản học viên");
                        break;
                    }
                    
                    targetUserId = Integer.parseInt(request.getParameter("userId"));
                    reason = request.getParameter("reason");
                    String requestType = request.getParameter("requestType"); // "lock" or "unlock"
                    
                    // Check if account is already locked (only for lock requests)
                    if ("lock".equals(requestType)) {
                        com.example.model.User targetUserCheck = userDAO.getUserById(targetUserId);
                        if (targetUserCheck != null && targetUserCheck.isLocked()) {
                            com.example.model.User lockedByUser = userDAO.getUserById(targetUserCheck.getLockedBy());
                            String lockedByName = lockedByUser != null ? lockedByUser.getFullname() : "Không rõ";
                            String lockedDate = targetUserCheck.getLockedAt() != null ? targetUserCheck.getLockedAt().toString() : "Không rõ";
                            result.put("success", false);
                            result.put("message", "Tài khoản này đã bị khóa!\n" +
                                                  "Bởi: " + lockedByName + "\n" +
                                                  "Lý do: " + targetUserCheck.getLockedReason() + "\n" +
                                                  "Ngày giờ: " + lockedDate);
                            break;
                        }
                    }
                    
                    if (createLockRequest(targetUserId, currentUserId, reason, requestType)) {
                        result.put("success", true);
                        result.put("message", "Đã gửi yêu cầu thành công. Chờ admin duyệt.");
                    } else {
                        result.put("success", false);
                        result.put("message", "Không thể gửi yêu cầu");
                    }
                    break;
                    
                case "approve":
                    // Admin approves lock request
                    if (!"admin@ptit.edu.vn".equals(userEmail)) {
                        result.put("success", false);
                        result.put("message", "Chỉ admin mới có quyền duyệt yêu cầu");
                        break;
                    }
                    
                    int requestId = Integer.parseInt(request.getParameter("requestId"));
                    String reviewNote = request.getParameter("reviewNote");
                    
                    if (approveRequest(requestId, currentUserId, reviewNote)) {
                        result.put("success", true);
                        result.put("message", "Đã duyệt yêu cầu thành công");
                    } else {
                        result.put("success", false);
                        result.put("message", "Không thể duyệt yêu cầu");
                    }
                    break;
                    
                case "reject":
                    // Admin rejects lock request
                    if (!"admin@ptit.edu.vn".equals(userEmail)) {
                        result.put("success", false);
                        result.put("message", "Chỉ admin mới có quyền từ chối yêu cầu");
                        break;
                    }
                    
                    requestId = Integer.parseInt(request.getParameter("requestId"));
                    reviewNote = request.getParameter("reviewNote");
                    
                    if (rejectRequest(requestId, currentUserId, reviewNote)) {
                        result.put("success", true);
                        result.put("message", "Đã từ chối yêu cầu");
                    } else {
                        result.put("success", false);
                        result.put("message", "Không thể từ chối yêu cầu");
                    }
                    break;
                    
                default:
                    result.put("success", false);
                    result.put("message", "Hành động không hợp lệ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi hệ thống: " + e.getMessage());
        }
        
        response.getWriter().write(gson.toJson(result));
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\": false, \"message\": \"Chưa đăng nhập\"}");
            return;
        }
        
        String userEmail = (String) session.getAttribute("userEmail");
        String action = request.getParameter("action");
        
        Map<String, Object> result = new HashMap<>();
        
        try {
            if ("getPendingRequests".equals(action)) {
                // Get pending lock requests (for admin)
                if ("admin@ptit.edu.vn".equals(userEmail)) {
                    List<Map<String, Object>> requests = getPendingRequests();
                    result.put("success", true);
                    result.put("requests", requests);
                } else {
                    result.put("success", false);
                    result.put("message", "Chỉ admin mới có quyền xem yêu cầu chờ duyệt");
                }
            } else if ("getMyRequests".equals(action)) {
                // Get teacher's own requests
                int userId = (int) session.getAttribute("userId");
                List<Map<String, Object>> requests = getTeacherRequests(userId);
                result.put("success", true);
                result.put("requests", requests);
            } else if ("getReviewedRequests".equals(action)) {
                // Get reviewed (approved/rejected) lock requests (for admin)
                if ("admin@ptit.edu.vn".equals(userEmail)) {
                    List<Map<String, Object>> requests = getReviewedRequests();
                    result.put("success", true);
                    result.put("requests", requests);
                } else {
                    result.put("success", false);
                    result.put("message", "Chỉ admin mới có quyền xem lịch sử duyệt");
                }
            } else {
                result.put("success", false);
                result.put("message", "Hành động không hợp lệ");
            }
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi hệ thống: " + e.getMessage());
        }
        
        response.getWriter().write(gson.toJson(result));
    }
    
    private boolean createLockRequest(int targetUserId, int requesterId, String reason, String requestType) {
        String sql = "INSERT INTO account_lock_requests (target_user_id, requester_id, reason, request_type) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, targetUserId);
            stmt.setInt(2, requesterId);
            stmt.setString(3, reason);
            stmt.setString(4, requestType);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private boolean approveRequest(int requestId, int adminId, String reviewNote) {
        Connection conn = null;
        try {
            conn = DatabaseConnection.getNewConnection();
            conn.setAutoCommit(false);
            
            // Get request details
            String getSql = "SELECT target_user_id, request_type FROM account_lock_requests WHERE request_id = ? AND status = 'pending'";
            int targetUserId = 0;
            String requestType = "";
            
            try (PreparedStatement stmt = conn.prepareStatement(getSql)) {
                stmt.setInt(1, requestId);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    targetUserId = rs.getInt("target_user_id");
                    requestType = rs.getString("request_type");
                } else {
                    return false;
                }
            }
            
            // Update request status
            String updateSql = "UPDATE account_lock_requests SET status = 'approved', reviewed_by = ?, reviewed_at = CURRENT_TIMESTAMP, review_note = ? WHERE request_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
                stmt.setInt(1, adminId);
                stmt.setString(2, reviewNote);
                stmt.setInt(3, requestId);
                stmt.executeUpdate();
            }
            
            // Perform the lock/unlock action
            if ("lock".equals(requestType)) {
                // Check if account is already locked before approving
                com.example.model.User targetUser = userDAO.getUserById(targetUserId);
                if (targetUser != null && targetUser.isLocked()) {
                    // Account already locked, rollback transaction
                    conn.rollback();
                    return false;
                }
                userDAO.lockUserAccount(targetUserId, reviewNote != null ? reviewNote : "Được duyệt bởi admin", adminId);
            } else if ("unlock".equals(requestType)) {
                userDAO.unlockUserAccount(targetUserId);
            }
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    private boolean rejectRequest(int requestId, int adminId, String reviewNote) {
        String sql = "UPDATE account_lock_requests SET status = 'rejected', reviewed_by = ?, reviewed_at = CURRENT_TIMESTAMP, review_note = ? WHERE request_id = ?";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, adminId);
            stmt.setString(2, reviewNote);
            stmt.setInt(3, requestId);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private List<Map<String, Object>> getPendingRequests() {
        List<Map<String, Object>> requests = new ArrayList<>();
        String sql = "SELECT * FROM account_lock_requests_view WHERE status = 'pending' ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> request = new HashMap<>();
                request.put("requestId", rs.getInt("request_id"));
                request.put("targetUserId", rs.getInt("target_user_id"));
                request.put("targetFullname", rs.getString("target_fullname"));
                request.put("targetEmail", rs.getString("target_email"));
                request.put("targetPhone", rs.getString("target_phone"));
                request.put("requesterId", rs.getInt("requester_id"));
                request.put("requesterFullname", rs.getString("requester_fullname"));
                request.put("requesterEmail", rs.getString("requester_email"));
                request.put("reason", rs.getString("reason"));
                request.put("requestType", rs.getString("request_type"));
                request.put("createdAt", rs.getTimestamp("created_at").toString());
                request.put("targetIsLocked", rs.getBoolean("target_is_locked"));
                requests.add(request);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
    
    private List<Map<String, Object>> getTeacherRequests(int teacherId) {
        List<Map<String, Object>> requests = new ArrayList<>();
        String sql = "SELECT * FROM account_lock_requests_view WHERE requester_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, teacherId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> request = new HashMap<>();
                request.put("requestId", rs.getInt("request_id"));
                request.put("targetFullname", rs.getString("target_fullname"));
                request.put("targetEmail", rs.getString("target_email"));
                request.put("reason", rs.getString("reason"));
                request.put("requestType", rs.getString("request_type"));
                request.put("status", rs.getString("status"));
                request.put("createdAt", rs.getTimestamp("created_at").toString());
                request.put("reviewedAt", rs.getTimestamp("reviewed_at") != null ? rs.getTimestamp("reviewed_at").toString() : null);
                request.put("reviewNote", rs.getString("review_note"));
                request.put("reviewerFullname", rs.getString("reviewer_fullname"));
                requests.add(request);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
    
    private List<Map<String, Object>> getReviewedRequests() {
        List<Map<String, Object>> requests = new ArrayList<>();
        String sql = "SELECT * FROM account_lock_requests_view WHERE status IN ('approved', 'rejected') ORDER BY reviewed_at DESC LIMIT 100";
        
        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> request = new HashMap<>();
                request.put("requestId", rs.getInt("request_id"));
                request.put("targetUserId", rs.getInt("target_user_id"));
                request.put("targetFullname", rs.getString("target_fullname"));
                request.put("targetEmail", rs.getString("target_email"));
                request.put("targetPhone", rs.getString("target_phone"));
                request.put("requesterId", rs.getInt("requester_id"));
                request.put("requesterFullname", rs.getString("requester_fullname"));
                request.put("requesterEmail", rs.getString("requester_email"));
                request.put("reason", rs.getString("reason"));
                request.put("requestType", rs.getString("request_type"));
                request.put("status", rs.getString("status"));
                request.put("createdAt", rs.getTimestamp("created_at").toString());
                request.put("reviewedAt", rs.getTimestamp("reviewed_at") != null ? rs.getTimestamp("reviewed_at").toString() : null);
                request.put("reviewNote", rs.getString("review_note"));
                request.put("reviewerFullname", rs.getString("reviewer_fullname"));
                requests.add(request);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return requests;
    }
}
