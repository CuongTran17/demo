package com.example.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Course {
    private String courseId;
    private String courseName;
    private String category;
    private String description;
    private BigDecimal price;
    private BigDecimal oldPrice;
    private String duration;
    private int studentsCount;
    private String level;
    private String thumbnail;
    private boolean isNew;
    private int discountPercentage;
    private Timestamp createdAt;
    
    // Constructors
    public Course() {}
    
    public Course(String courseId, String courseName, String category, BigDecimal price) {
        this.courseId = courseId;
        this.courseName = courseName;
        this.category = category;
        this.price = price;
    }
    
    // Getters and Setters
    public String getCourseId() {
        return courseId;
    }
    
    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }
    
    public String getCourseName() {
        return courseName;
    }
    
    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public BigDecimal getOldPrice() {
        return oldPrice;
    }
    
    public void setOldPrice(BigDecimal oldPrice) {
        this.oldPrice = oldPrice;
    }
    
    public String getDuration() {
        return duration;
    }
    
    public void setDuration(String duration) {
        this.duration = duration;
    }
    
    public int getStudentsCount() {
        return studentsCount;
    }
    
    public void setStudentsCount(int studentsCount) {
        this.studentsCount = studentsCount;
    }
    
    public String getLevel() {
        return level;
    }
    
    public void setLevel(String level) {
        this.level = level;
    }
    
    public String getThumbnail() {
        return thumbnail;
    }
    
    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }
    
    public boolean isNew() {
        return isNew;
    }
    
    public void setNew(boolean isNew) {
        this.isNew = isNew;
    }
    
    public int getDiscountPercentage() {
        return discountPercentage;
    }
    
    public void setDiscountPercentage(int discountPercentage) {
        this.discountPercentage = discountPercentage;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
