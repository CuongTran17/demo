package com.example.servlets;

import com.example.dao.LessonDAO;
import com.example.model.Lesson;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/api/lessons")
public class LessonServlet extends HttpServlet {
    private LessonDAO lessonDAO;
    private ObjectMapper objectMapper;

    @Override
    public void init() throws ServletException {
        lessonDAO = new LessonDAO();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String courseId = request.getParameter("courseId");
            String sectionIdParam = request.getParameter("sectionId");
            String lessonIdParam = request.getParameter("lessonId");

            if (lessonIdParam != null) {
                // Get single lesson
                int lessonId = Integer.parseInt(lessonIdParam);
                Lesson lesson = lessonDAO.getLessonById(lessonId);
                if (lesson != null) {
                    out.print(objectMapper.writeValueAsString(lesson));
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print("{\"error\": \"Lesson not found\"}");
                }
            } else if (courseId != null && sectionIdParam != null) {
                // Get lessons by course and section
                int sectionId = Integer.parseInt(sectionIdParam);
                List<Lesson> lessons = lessonDAO.getLessonsBySection(courseId, sectionId);
                out.print(objectMapper.writeValueAsString(lessons));
            } else if (courseId != null) {
                // Get all lessons for a course
                List<Lesson> lessons = lessonDAO.getLessonsByCourseId(courseId);
                out.print(objectMapper.writeValueAsString(lessons));
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"courseId parameter is required\"}");
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid number format\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Parse JSON request body
            Lesson lesson = objectMapper.readValue(request.getReader(), Lesson.class);

            // Validate required fields
            if (lesson.getCourseId() == null || lesson.getLessonTitle() == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"courseId and lessonTitle are required\"}");
                return;
            }

            // Set next lesson order if not provided
            if (lesson.getLessonOrder() == 0) {
                lesson.setLessonOrder(lessonDAO.getNextLessonOrder(lesson.getCourseId(), lesson.getSectionId()));
            }

            // Save lesson
            int lessonId = lessonDAO.saveLesson(lesson);
            if (lessonId > 0) {
                lesson.setLessonId(lessonId);
                out.print(objectMapper.writeValueAsString(lesson));
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\": \"Failed to save lesson\"}");
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid request format: " + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Parse JSON request body
            Lesson lesson = objectMapper.readValue(request.getReader(), Lesson.class);

            // Validate required fields
            if (lesson.getLessonId() == 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"lessonId is required for update\"}");
                return;
            }

            // Update lesson
            boolean success = lessonDAO.updateLesson(lesson);
            if (success) {
                out.print("{\"success\": true, \"message\": \"Lesson updated successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\": \"Lesson not found or update failed\"}");
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid request format: " + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            String lessonIdParam = request.getParameter("lessonId");
            if (lessonIdParam == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"lessonId parameter is required\"}");
                return;
            }

            int lessonId = Integer.parseInt(lessonIdParam);
            boolean success = lessonDAO.deleteLesson(lessonId);

            if (success) {
                out.print("{\"success\": true, \"message\": \"Lesson deleted successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"error\": \"Lesson not found or delete failed\"}");
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Database error: " + e.getMessage() + "\"}");
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"error\": \"Invalid lessonId format\"}");
        }
    }
}