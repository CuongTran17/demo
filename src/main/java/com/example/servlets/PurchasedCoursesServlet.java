package com.example.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import com.example.dao.CourseDAO;
import com.example.dao.OrderDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/api/purchased-courses")
public class PurchasedCoursesServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        JSONObject jsonResponse = new JSONObject();
        
        // Check if user is logged in
        if (userId == null) {
            jsonResponse.put("loggedIn", false);
            jsonResponse.put("purchasedCourses", new JSONArray());
            
            PrintWriter out = response.getWriter();
            out.print(jsonResponse.toString());
            out.flush();
            return;
        }
        
        try {
            // Get all purchased course IDs for this user
            OrderDAO orderDAO = new OrderDAO();
            List<String> purchasedCourseIds = orderDAO.getPurchasedCoursesByUser(userId);
            
            JSONArray coursesArray = new JSONArray();
            for (String courseId : purchasedCourseIds) {
                coursesArray.put(courseId);
            }
            
            jsonResponse.put("loggedIn", true);
            jsonResponse.put("purchasedCourses", coursesArray);
            
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("loggedIn", true);
            jsonResponse.put("purchasedCourses", new JSONArray());
            jsonResponse.put("error", "Error retrieving purchased courses");
        }
        
        PrintWriter out = response.getWriter();
        out.print(jsonResponse.toString());
        out.flush();
    }
}
