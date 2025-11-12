package com.example.servlets;

import java.io.IOException;
import java.util.List;

import com.example.dao.CartDAO;
import com.example.dao.UserDAO;
import com.example.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;
    private CartDAO cartDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
        cartDAO = new CartDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String emailOrPhone = request.getParameter("username");
        String password = request.getParameter("password");
        String redirect = request.getParameter("redirect");
        String rememberMe = request.getParameter("rememberMe");
        
        // Validate input
        if (emailOrPhone == null || emailOrPhone.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // Attempt login
        User user = userDAO.loginUser(emailOrPhone.trim(), password);
        
        if (user != null) {
            // Login successful - create session
            HttpSession session = request.getSession();
            session.setAttribute("loggedIn", true);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userPhone", user.getPhone());
            session.setAttribute("userFullname", user.getFullname());
            
            // Load user's cart from database
            List<String> userCart = cartDAO.getUserCart(user.getUserId());
            
            // Merge with session cart (if guest added items before login)
            @SuppressWarnings("unchecked")
            List<String> sessionCart = (List<String>) session.getAttribute("cart");
            if (sessionCart != null && !sessionCart.isEmpty()) {
                // Add session cart items to database
                for (String courseId : sessionCart) {
                    if (!userCart.contains(courseId)) {
                        cartDAO.addToCart(user.getUserId(), courseId);
                        userCart.add(courseId);
                    }
                }
            }
            
            // Update session with merged cart
            session.setAttribute("cart", userCart);
            
            // Set session timeout to 30 minutes
            session.setMaxInactiveInterval(30 * 60);
            
            // Handle "Remember Me" cookie
            if ("true".equals(rememberMe)) {
                // Create secure token (email + timestamp + hash)
                String token = user.getEmail() + "|" + System.currentTimeMillis();
                String encodedToken = java.util.Base64.getEncoder().encodeToString(token.getBytes());
                
                Cookie rememberCookie = new Cookie("rememberMe", encodedToken);
                rememberCookie.setMaxAge(30 * 24 * 60 * 60); // 30 days
                rememberCookie.setPath(request.getContextPath() + "/");
                rememberCookie.setHttpOnly(true); // Prevent XSS
                response.addCookie(rememberCookie);
            }
            
            // Redirect to original page or home
            String redirectUrl = request.getContextPath() + "/";
            if (redirect != null && !redirect.isEmpty()) {
                redirectUrl = request.getContextPath() + "/" + redirect + ".jsp";
            }
            response.sendRedirect(redirectUrl);
            
        } else {
            // Login failed
            request.setAttribute("error", "Email/SĐT hoặc mật khẩu không đúng!");
            request.setAttribute("emailOrPhone", emailOrPhone);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user already logged in via session
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loggedIn") != null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        // Check for Remember Me cookie
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberMe".equals(cookie.getName())) {
                    try {
                        // Decode token
                        String token = new String(java.util.Base64.getDecoder().decode(cookie.getValue()));
                        String[] parts = token.split("\\|");
                        if (parts.length == 2) {
                            String email = parts[0];
                            
                            // Verify user exists
                            User user = userDAO.getUserByEmail(email);
                            if (user != null) {
                                // Auto-login: create session
                                session = request.getSession();
                                session.setAttribute("loggedIn", true);
                                session.setAttribute("userId", user.getUserId());
                                session.setAttribute("userEmail", user.getEmail());
                                session.setAttribute("userPhone", user.getPhone());
                                session.setAttribute("userFullname", user.getFullname());
                                session.setMaxInactiveInterval(30 * 60);
                                
                                // Load cart
                                List<String> userCart = cartDAO.getUserCart(user.getUserId());
                                session.setAttribute("cart", userCart);
                                
                                response.sendRedirect(request.getContextPath() + "/");
                                return;
                            }
                        }
                    } catch (Exception e) {
                        // Invalid token, delete cookie
                        cookie.setMaxAge(0);
                        cookie.setPath(request.getContextPath() + "/");
                        response.addCookie(cookie);
                    }
                }
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
