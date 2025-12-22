package com.example.servlets;

import java.io.IOException;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.example.dao.CourseDAO;
import com.example.model.Course;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/courses")
public class CourseServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(CourseServlet.class);
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
            String targetPage = (category != null) ? switch (category.toLowerCase()) {
                case "python" -> "/courses-python.jsp";
                case "finance" -> "/courses-finance.jsp";
                case "marketing" -> "/courses-marketing.jsp";
                case "data" -> "/courses-data.jsp";
                case "blockchain" -> "/courses-blockchain.jsp";
                case "accounting" -> "/courses-accounting.jsp";
                default -> "/index.jsp";
            } : "/index.jsp";
            
            request.getRequestDispatcher(targetPage).forward(request, response);
            
        } catch (ServletException | IOException e) {
            logger.error("Servlet or IO error in course loading", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error loading courses: " + e.getMessage());
        } catch (Exception e) {
            logger.error("Unexpected error in course loading", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error loading courses: " + e.getMessage());
        }
    }
}
