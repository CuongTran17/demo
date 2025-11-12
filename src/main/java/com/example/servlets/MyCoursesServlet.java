package com.example.servlets;

import java.io.IOException;
import java.util.List;

import com.example.dao.CourseDAO;
import com.example.model.Course;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/my-courses")
public class MyCoursesServlet extends HttpServlet {
    private CourseDAO courseDAO;
    
    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
        Integer userId = (Integer) session.getAttribute("userId");
        
        // Check if user is logged in
        if (loggedIn == null || !loggedIn || userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=my-courses");
            return;
        }
        
        try {
            // Get user's purchased courses
            List<Course> myCourses = courseDAO.getUserCourses(userId);
            
            request.setAttribute("myCourses", myCourses);
            request.getRequestDispatcher("/my-courses.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error loading courses: " + e.getMessage());
        }
    }
}
