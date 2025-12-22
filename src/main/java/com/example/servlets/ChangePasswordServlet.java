package com.example.servlets;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.example.dao.UserDAO;
import com.example.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/changePassword")
public class ChangePasswordServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(ChangePasswordServlet.class);
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        
        try {
            // Verify current password
            User user = userDAO.getUserById(userId);
            String currentPasswordHash = UserDAO.hashPassword(currentPassword);
            
            if (!currentPasswordHash.equals(user.getPasswordHash())) {
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Mật khẩu hiện tại không đúng\"}");
                return;
            }
            
            // Update to new password
            String newPasswordHash = UserDAO.hashPassword(newPassword);
            boolean updated = userDAO.updatePassword(userId, newPasswordHash);
            
            if (updated) {
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"success\": true, \"message\": \"Đổi mật khẩu thành công\"}");
            } else {
                response.setContentType("application/json; charset=UTF-8");
                response.getWriter().write("{\"success\": false, \"message\": \"Đổi mật khẩu thất bại\"}");
            }
        } catch (Exception e) {
            logger.error("Error changing password", e);
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi: " + e.getMessage() + "\"}");
        }
    }
}
