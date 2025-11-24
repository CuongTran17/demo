package com.example.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import com.example.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/api/check-email")
public class CheckEmailServlet extends HttpServlet {
    private UserDAO userDAO;
    
    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String email = request.getParameter("email");
        PrintWriter out = response.getWriter();
        
        System.out.println("CheckEmailServlet: Checking email: " + email);
        
        if (email == null || email.trim().isEmpty()) {
            System.out.println("CheckEmailServlet: Email is null or empty");
            out.print("{\"exists\": false}");
            return;
        }
        
        boolean exists = userDAO.emailExists(email.trim());
        System.out.println("CheckEmailServlet: Email " + email + " exists: " + exists);
        out.print("{\"exists\": " + exists + "}");
    }
}
