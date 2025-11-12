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

@WebServlet("/search")
public class SearchServlet extends HttpServlet {
    private CourseDAO courseDAO;
    
    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get search parameters
        String keyword = request.getParameter("q");
        String category = request.getParameter("category");
        String priceRange = request.getParameter("price");
        String sortBy = request.getParameter("sort");
        
        // Default values
        if (keyword == null) keyword = "";
        if (category == null) category = "all";
        if (priceRange == null) priceRange = "all";
        if (sortBy == null) sortBy = "newest";
        
        // Search courses from database
        List<Course> courses = courseDAO.searchCourses(keyword, category, priceRange, sortBy);
        
        // Set attributes for JSP
        request.setAttribute("courses", courses);
        request.setAttribute("keyword", keyword);
        request.setAttribute("category", category);
        request.setAttribute("priceRange", priceRange);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("totalResults", courses.size());
        
        // Forward to search.jsp
        request.getRequestDispatcher("/search.jsp").forward(request, response);
    }
}
