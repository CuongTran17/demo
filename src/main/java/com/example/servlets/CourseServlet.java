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

@WebServlet("/courses")
public class CourseServlet extends HttpServlet {
    private CourseDAO courseDAO;
    
    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String category = request.getParameter("category");
        
        try {
            List<Course> courses;
            
            if (category != null && !category.isEmpty()) {
                // Get courses by category
                courses = courseDAO.getCoursesByCategory(category);
                request.setAttribute("category", category);
            } else {
                // Get all courses
                courses = courseDAO.getAllCourses();
            }
            
            request.setAttribute("courses", courses);
            
            // Forward to appropriate JSP based on category
            String targetPage;
            if (category != null) {
                switch (category.toLowerCase()) {
                    case "python":
                        targetPage = "/courses-python.jsp";
                        break;
                    case "finance":
                        targetPage = "/courses-finance.jsp";
                        break;
                    case "marketing":
                        targetPage = "/courses-marketing.jsp";
                        break;
                    case "data":
                        targetPage = "/courses-data.jsp";
                        break;
                    case "blockchain":
                        targetPage = "/courses-blockchain.jsp";
                        break;
                    case "accounting":
                        targetPage = "/courses-accounting.jsp";
                        break;
                    default:
                        targetPage = "/index.jsp";
                }
            } else {
                targetPage = "/index.jsp";
            }
            
            request.getRequestDispatcher(targetPage).forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error loading courses: " + e.getMessage());
        }
    }
}
