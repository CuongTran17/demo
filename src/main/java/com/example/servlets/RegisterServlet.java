package com.example.servlets;

import java.io.IOException;

import com.example.dao.UserDAO;
import com.example.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/signup")
public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullname = request.getParameter("fullname");
        
        // Validate input
        if (email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            fullname == null || fullname.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }
        
        // Check password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.setAttribute("fullname", fullname);
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }
        
        // Check if email already exists
        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email đã được sử dụng!");
            request.setAttribute("phone", phone);
            request.setAttribute("fullname", fullname);
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }
        
        // Check if phone already exists
        if (userDAO.phoneExists(phone)) {
            request.setAttribute("error", "Số điện thoại đã được sử dụng!");
            request.setAttribute("email", email);
            request.setAttribute("fullname", fullname);
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }
        
        // Create new user
        User user = new User();
        user.setEmail(email.trim());
        user.setPhone(phone.trim());
        user.setPasswordHash(UserDAO.hashPassword(password));
        user.setFullname(fullname.trim());
        
        boolean success = userDAO.registerUser(user);
        
        if (success) {
            // Registration successful - auto login
            HttpSession session = request.getSession();
            session.setAttribute("loggedIn", true);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userPhone", user.getPhone());
            session.setAttribute("userFullname", user.getFullname());
            session.setMaxInactiveInterval(30 * 60);
            
            // Set success message for popup
            session.setAttribute("successMessage", "Đăng ký thành công! Chào mừng " + user.getFullname() + " đến với PTIT Learning!");
            
            response.sendRedirect(request.getContextPath() + "/");
        } else {
            request.setAttribute("error", "Đăng ký thất bại! Vui lòng thử lại.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/signup.jsp");
    }
}
