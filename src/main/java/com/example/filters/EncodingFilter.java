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

public class EncodingFilter implements Filter {
    
    private String encoding;
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        encoding = filterConfig.getInitParameter("encoding");
        if (encoding == null) {
            encoding = "UTF-8";
        }
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Force UTF-8 encoding for all requests
        httpRequest.setCharacterEncoding(encoding);
        httpResponse.setCharacterEncoding(encoding);
        
        String requestURI = httpRequest.getRequestURI();
        
        // Set content type for JSP/HTML files
        if (requestURI.endsWith(".jsp") || requestURI.endsWith(".html") || requestURI.equals("/") || 
            (!requestURI.contains(".") && !requestURI.startsWith("/teacher") && !requestURI.startsWith("/api"))) {
            httpResponse.setContentType("text/html; charset=" + encoding);
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup code here if needed
    }
}