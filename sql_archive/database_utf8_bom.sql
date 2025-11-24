-- ============================================
-- PTIT LEARNING - Complete Database with UTF-8 BOM
-- ============================================

DROP DATABASE IF EXISTS ptit_learning;
CREATE DATABASE ptit_learning CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ptit_learning;

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- Create users table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    fullname VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create courses table
CREATE TABLE courses (
    course_id VARCHAR(50) PRIMARY KEY,
    course_name VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    old_price DECIMAL(10,2),
    duration VARCHAR(50),
    students_count INT DEFAULT 0,
    level VARCHAR(20),
    thumbnail VARCHAR(255),
    is_new TINYINT(1) DEFAULT 0,
    discount_percentage INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert users with Vietnamese names
INSERT INTO users (email, phone, password_hash, fullname) VALUES
('admin@ptit.edu.vn', '0123456789', '$2a$10$dummyhash1', 'Administrator'),
('teacher1@ptit.edu.vn', '0123456781', '$2a$10$dummyhash2', 'Nguyễn Văn Python'),
('teacher2@ptit.edu.vn', '0123456782', '$2a$10$dummyhash3', 'Trần Thị Finance'),
('teacher3@ptit.edu.vn', '0123456783', '$2a$10$dummyhash4', 'Lê Văn Data'),
('teacher4@ptit.edu.vn', '0123456784', '$2a$10$dummyhash5', 'Phạm Thị Blockchain'),
('teacher5@ptit.edu.vn', '0123456785', '$2a$10$dummyhash6', 'Hoàng Văn Accounting'),
('teacher6@ptit.edu.vn', '0123456786', '$2a$10$dummyhash7', 'Vũ Thị Marketing'),
('tranduccuong17@gmail.com', '0987654321', '$2a$10$N9qo8uLOickgx2ZMRZoMye', 'Trần Đức Cường'),
('student1@gmail.com', '0987654322', '$2a$10$dummyhash8', 'Trần Thị Mai');

-- Insert Python courses
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('python-procedural', 'Procedural Python - Lập trình hàm trong Python', 'python', 'Học lập trình hàm trong Python từ cơ bản đến nâng cao, áp dụng vào dự án thực tế', 1299000, 2499000, '12 giờ', 1234, 'Beginner', 'assets/img/courses-python/python-procedural.png', 1, 48),
('python-basics', 'Python Basics - Lập trình Python cơ bản', 'python', 'Khóa học Python cho người mới bắt đầu, từ zero đến hero', 999000, 1999000, '10 giờ', 2567, 'Beginner', 'assets/img/courses-python/python-basics.png', 0, 50),
('python-complete', 'Python Toàn Tập - Từ Zero Đến Hero', 'python', 'Khóa học Python toàn diện nhất, bao gồm tất cả kiến thức cần thiết', 2499000, 4999000, '40 giờ', 5678, 'All', 'assets/img/courses-python/python-complete.png', 0, 50),
('python-excel', 'Python Excel cho người đi làm', 'python', 'Tự động hóa Excel bằng Python, tiết kiệm thời gian làm việc', 899000, 1799000, '8 giờ', 1890, 'Intermediate', 'assets/img/courses-python/python-excel.png', 0, 50),
('selenium-python', 'Selenium Python - Test Automation', 'python', 'Automation testing với Selenium và Python', 1599000, 2999000, '18 giờ', 987, 'Advanced', 'assets/img/courses-python/selenium-python.png', 0, 47),
('python-oop', 'Python OOP - Lập trình hướng đối tượng', 'python', 'Lập trình hướng đối tượng với Python, từ cơ bản đến nâng cao', 1199000, 2399000, '14 giờ', 756, 'Intermediate', 'assets/img/courses-python/python-oop.png', 0, 50);
