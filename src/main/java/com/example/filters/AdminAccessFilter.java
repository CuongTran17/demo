package com.example.filters;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class AdminAccessFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String path = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Allow access to static resources and login pages
        if (path.startsWith(contextPath + "/assets/") || 
            path.startsWith(contextPath + "/login") ||
            path.startsWith(contextPath + "/signup") ||
            path.startsWith(contextPath + "/logout") ||
            path.startsWith(contextPath + "/test-")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if accessing admin page
        if (path.startsWith(contextPath + "/admin")) {
            if (session == null || session.getAttribute("userId") == null) {
                httpResponse.sendRedirect(contextPath + "/login.jsp");
                return;
            }
            
            String userEmail = (String) session.getAttribute("userEmail");
            if (!"admin@ptit.edu.vn".equals(userEmail)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, 
                    "Chỉ tài khoản quản trị viên mới có thể truy cập trang này");
                return;
            }
        }
        
        // Check if admin trying to access non-admin pages
        if (session != null && session.getAttribute("userId") != null) {
            String userEmail = (String) session.getAttribute("userEmail");
            if ("admin@ptit.edu.vn".equals(userEmail)) {
                // Allow admin to access admin and logout pages only
                if (!path.startsWith(contextPath + "/admin") && 
                    !path.startsWith(contextPath + "/logout")) {
                    httpResponse.sendRedirect(contextPath + "/admin");
                    return;
                }
            }
        }
        
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
