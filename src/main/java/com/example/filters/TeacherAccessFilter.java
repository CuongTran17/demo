package com.example.filters;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Filter to restrict teacher account access to only teacher pages
 * Teacher can only access /teacher and /logout, cannot access student pages
 */
// @WebFilter("/*") - Disabled: Using web.xml configuration instead
public class TeacherAccessFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Get current path
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());
        
        // Check if user is logged in and is teacher
        if (session != null) {
            String userEmail = (String) session.getAttribute("userEmail");
            Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
            
            if (loggedIn != null && loggedIn && userEmail != null && userEmail.matches("teacher\\d*@ptit\\.edu\\.vn")) {
                // Teacher is logged in - restrict access
                
                // Allow these paths for teacher
                if (path.equals("/teacher") || 
                    path.equals("/logout") ||
                    path.equals("/login.jsp") ||
                    path.equals("/login") ||
                    path.startsWith("/assets/") ||
                    path.startsWith("/api/") ||
                    path.startsWith("/test-")) {
                    // Allow access
                    chain.doFilter(request, response);
                    return;
                }
                
                // Block access to all other pages for teacher
                // Redirect to teacher dashboard
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/teacher");
                return;
            }
        }
        
        // Not a teacher or not logged in - allow normal access
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
