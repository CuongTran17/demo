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
        
        // Set request encoding
        if (httpRequest.getCharacterEncoding() == null) {
            httpRequest.setCharacterEncoding(encoding);
        }
        
        String requestURI = httpRequest.getRequestURI();
        
        // Only set content type for JSP/HTML files, not for CSS/JS/images
        if (requestURI.endsWith(".jsp") || requestURI.endsWith(".html") || requestURI.equals("/") || !requestURI.contains(".")) {
            // Set response encoding only for HTML/JSP pages
            httpResponse.setCharacterEncoding(encoding);
            httpResponse.setContentType("text/html; charset=" + encoding);
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup code here if needed
    }
}