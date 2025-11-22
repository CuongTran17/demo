package com.example.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.example.model.Lesson;
import com.example.util.DatabaseConnection;

public class LessonDAO {

    public List<Lesson> getLessonsByCourseId(String courseId) throws SQLException {
        List<Lesson> lessons = new ArrayList<>();
        String sql = "SELECT * FROM lessons WHERE course_id = ? AND is_active = true ORDER BY section_id, lesson_order";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, courseId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Lesson lesson = mapResultSetToLesson(rs);
                lessons.add(lesson);
            }
        }
        return lessons;
    }

    public Lesson getLessonById(int lessonId) throws SQLException {
        String sql = "SELECT * FROM lessons WHERE lesson_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, lessonId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToLesson(rs);
            }
        }
        return null;
    }

    public int saveLesson(Lesson lesson) throws SQLException {
        String sql = "INSERT INTO lessons (course_id, section_id, lesson_title, lesson_content, " +
                    "video_url, duration, lesson_order, is_active, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, true, NOW(), NOW())";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, lesson.getCourseId());
            stmt.setInt(2, lesson.getSectionId());
            stmt.setString(3, lesson.getLessonTitle());
            stmt.setString(4, lesson.getLessonContent());
            stmt.setString(5, lesson.getVideoUrl());
            stmt.setString(6, lesson.getDuration());
            stmt.setInt(7, lesson.getLessonOrder());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        }
        return -1;
    }

    public boolean updateLesson(Lesson lesson) throws SQLException {
        String sql = "UPDATE lessons SET lesson_title = ?, lesson_content = ?, video_url = ?, " +
                    "duration = ?, lesson_order = ?, updated_at = NOW() WHERE lesson_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, lesson.getLessonTitle());
            stmt.setString(2, lesson.getLessonContent());
            stmt.setString(3, lesson.getVideoUrl());
            stmt.setString(4, lesson.getDuration());
            stmt.setInt(5, lesson.getLessonOrder());
            stmt.setInt(6, lesson.getLessonId());

            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteLesson(int lessonId) throws SQLException {
        String sql = "UPDATE lessons SET is_active = false, updated_at = NOW() WHERE lesson_id = ?";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, lessonId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Lesson> getLessonsBySection(String courseId, int sectionId) throws SQLException {
        List<Lesson> lessons = new ArrayList<>();
        String sql = "SELECT * FROM lessons WHERE course_id = ? AND section_id = ? AND is_active = true " +
                    "ORDER BY lesson_order";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, courseId);
            stmt.setInt(2, sectionId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Lesson lesson = mapResultSetToLesson(rs);
                lessons.add(lesson);
            }
        }
        return lessons;
    }

    public int getNextLessonOrder(String courseId, int sectionId) throws SQLException {
        String sql = "SELECT COALESCE(MAX(lesson_order), 0) + 1 FROM lessons " +
                    "WHERE course_id = ? AND section_id = ? AND is_active = true";

        try (Connection conn = DatabaseConnection.getNewConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, courseId);
            stmt.setInt(2, sectionId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 1;
    }

    private Lesson mapResultSetToLesson(ResultSet rs) throws SQLException {
        Lesson lesson = new Lesson();
        lesson.setLessonId(rs.getInt("lesson_id"));
        lesson.setCourseId(rs.getString("course_id"));
        lesson.setSectionId(rs.getInt("section_id"));
        lesson.setLessonTitle(rs.getString("lesson_title"));
        lesson.setLessonContent(rs.getString("lesson_content"));
        lesson.setVideoUrl(rs.getString("video_url"));
        lesson.setDuration(rs.getString("duration"));
        lesson.setLessonOrder(rs.getInt("lesson_order"));
        lesson.setActive(rs.getBoolean("is_active"));
        lesson.setCreatedAt(rs.getTimestamp("created_at"));
        lesson.setUpdatedAt(rs.getTimestamp("updated_at"));
        return lesson;
    }
}