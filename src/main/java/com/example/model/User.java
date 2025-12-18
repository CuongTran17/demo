package com.example.model;

import java.sql.Timestamp;

public class User {
    private int userId;
    private String email;
    private String phone;
    private String passwordHash;
    private String fullname;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private boolean isLocked;
    private String lockedReason;
    private Integer lockedBy;
    private Timestamp lockedAt;
    
    // Constructors
    public User() {}
    
    public User(String email, String phone, String passwordHash, String fullname) {
        this.email = email;
        this.phone = phone;
        this.passwordHash = passwordHash;
        this.fullname = fullname;
    }
    
    // Getters and Setters
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getPasswordHash() {
        return passwordHash;
    }
    
    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }
    
    public String getFullname() {
        return fullname;
    }
    
    public void setFullname(String fullname) {
        this.fullname = fullname;
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
    
    public boolean isLocked() {
        return isLocked;
    }
    
    public void setLocked(boolean locked) {
        isLocked = locked;
    }
    
    public String getLockedReason() {
        return lockedReason;
    }
    
    public void setLockedReason(String lockedReason) {
        this.lockedReason = lockedReason;
    }
    
    public Integer getLockedBy() {
        return lockedBy;
    }
    
    public void setLockedBy(Integer lockedBy) {
        this.lockedBy = lockedBy;
    }
    
    public Timestamp getLockedAt() {
        return lockedAt;
    }
    
    public void setLockedAt(Timestamp lockedAt) {
        this.lockedAt = lockedAt;
    }
}
