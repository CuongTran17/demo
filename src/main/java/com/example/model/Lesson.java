package com.example.model;

import java.sql.Timestamp;

public class Lesson {
    private int lessonId;
    private String courseId;
    private int sectionId;
    private String lessonTitle;
    private String lessonContent;
    private String videoUrl;
    private String duration;
    private int lessonOrder;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructors
    public Lesson() {}

    public Lesson(int lessonId, String courseId, int sectionId, String lessonTitle,
                  String lessonContent, String videoUrl, String duration, int lessonOrder) {
        this.lessonId = lessonId;
        this.courseId = courseId;
        this.sectionId = sectionId;
        this.lessonTitle = lessonTitle;
        this.lessonContent = lessonContent;
        this.videoUrl = videoUrl;
        this.duration = duration;
        this.lessonOrder = lessonOrder;
    }

    // Getters and Setters
    public int getLessonId() {
        return lessonId;
    }

    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
    }

    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    public int getSectionId() {
        return sectionId;
    }

    public void setSectionId(int sectionId) {
        this.sectionId = sectionId;
    }

    public String getLessonTitle() {
        return lessonTitle;
    }

    public void setLessonTitle(String lessonTitle) {
        this.lessonTitle = lessonTitle;
    }

    public String getLessonContent() {
        return lessonContent;
    }

    public void setLessonContent(String lessonContent) {
        this.lessonContent = lessonContent;
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public int getLessonOrder() {
        return lessonOrder;
    }

    public void setLessonOrder(int lessonOrder) {
        this.lessonOrder = lessonOrder;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Helper methods
    public String getVideoId() {
        if (videoUrl != null && (videoUrl.contains("youtube.com") || videoUrl.contains("youtu.be"))) {
            // Extract video ID from YouTube URL
            if (videoUrl.contains("v=")) {
                return videoUrl.split("v=")[1].split("&")[0];
            } else if (videoUrl.contains("youtu.be/")) {
                return videoUrl.split("youtu.be/")[1].split("\\?")[0];
            }
        }
        return videoUrl; // Return as-is if not YouTube URL
    }
}