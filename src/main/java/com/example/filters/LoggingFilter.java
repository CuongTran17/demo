package com.example.filters;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;

// @WebFilter("/*")  // Disabled for production - uncomment for debugging
public class LoggingFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Filter initialized
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        // HttpServletRequest httpRequest = (HttpServletRequest) request;
        // Uncomment below for debugging:
        // System.out.println("Request URL: " + httpRequest.getRequestURL());
        // System.out.println("Request Method: " + httpRequest.getMethod());
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Filter destroyed
    }
}