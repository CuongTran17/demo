package com.example.model;

import java.sql.Timestamp;

public class PendingChange {
    private int changeId;
    private int teacherId;
    private String teacherName;
    private String teacherEmail;
    private String changeType;
    private String targetId;
    private String changeData; // JSON string
    private String status;
    private Timestamp createdAt;
    private Timestamp reviewedAt;
    private Integer reviewedBy;
    private String reviewerName;
    private String reviewNote;
    
    // Getters and Setters
    public int getChangeId() { return changeId; }
    public void setChangeId(int changeId) { this.changeId = changeId; }
    
    public int getTeacherId() { return teacherId; }
    public void setTeacherId(int teacherId) { this.teacherId = teacherId; }
    
    public String getTeacherName() { return teacherName; }
    public void setTeacherName(String teacherName) { this.teacherName = teacherName; }
    
    public String getTeacherEmail() { return teacherEmail; }
    public void setTeacherEmail(String teacherEmail) { this.teacherEmail = teacherEmail; }
    
    public String getChangeType() { return changeType; }
    public void setChangeType(String changeType) { this.changeType = changeType; }
    
    public String getTargetId() { return targetId; }
    public void setTargetId(String targetId) { this.targetId = targetId; }
    
    public String getChangeData() { return changeData; }
    public void setChangeData(String changeData) { this.changeData = changeData; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public Timestamp getReviewedAt() { return reviewedAt; }
    public void setReviewedAt(Timestamp reviewedAt) { this.reviewedAt = reviewedAt; }
    
    public Integer getReviewedBy() { return reviewedBy; }
    public void setReviewedBy(Integer reviewedBy) { this.reviewedBy = reviewedBy; }
    
    public String getReviewerName() { return reviewerName; }
    public void setReviewerName(String reviewerName) { this.reviewerName = reviewerName; }
    
    public String getReviewNote() { return reviewNote; }
    public void setReviewNote(String reviewNote) { this.reviewNote = reviewNote; }
}
