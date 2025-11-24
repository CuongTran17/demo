-- ============================================
-- PTIT LEARNING - Complete Database Setup
-- Version: 2.0
-- Last Updated: 2025-11-22
-- ============================================

-- Create database with proper encoding
CREATE DATABASE IF NOT EXISTS ptit_learning 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE ptit_learning;

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- ============================================
-- DROP EXISTING TABLES (in correct order to avoid FK constraints)
-- ============================================
DROP TABLE IF EXISTS submissions;
DROP TABLE IF EXISTS assignments;
DROP TABLE IF EXISTS pending_changes;
DROP TABLE IF EXISTS teacher_courses;
DROP TABLE IF EXISTS lesson_progress;
DROP TABLE IF EXISTS lessons;
DROP TABLE IF EXISTS course_progress;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS user_courses;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS users;

-- ============================================
-- Table: users
-- Description: Store user accounts (students, teachers, admins)
-- ============================================
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

-- ============================================
-- Table: courses
-- Description: Store course information
-- ============================================
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

-- ============================================
-- Table: cart
-- Description: Store shopping cart items
-- ============================================
CREATE TABLE cart (
    cart_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    course_id VARCHAR(50) NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_user_course (user_id, course_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: orders
-- Description: Store order information
-- ============================================
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    order_note TEXT,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: order_items
-- Description: Store individual items in each order
-- ============================================
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    course_id VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id),
    INDEX idx_course_id (course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: course_progress
-- Description: Track user learning progress for each course
-- ============================================
CREATE TABLE course_progress (
    progress_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    course_id VARCHAR(50) NOT NULL,
    progress_percentage INT DEFAULT 0,
    total_hours DECIMAL(5,2) DEFAULT 0.00,
    last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'in_progress',
    UNIQUE KEY unique_user_course_progress (user_id, course_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: lessons
-- Description: Store lesson content for each course
-- ============================================
CREATE TABLE lessons (
    lesson_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id VARCHAR(50) NOT NULL,
    section_id INT NOT NULL DEFAULT 1,
    lesson_title VARCHAR(255) NOT NULL,
    lesson_content TEXT,
    video_url VARCHAR(500),
    duration VARCHAR(20),
    lesson_order INT DEFAULT 1,
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    INDEX idx_course_section (course_id, section_id),
    INDEX idx_lesson_order (lesson_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: lesson_progress
-- Description: Track individual lesson completion status
-- ============================================
CREATE TABLE lesson_progress (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    course_id VARCHAR(100) NOT NULL,
    lesson_id VARCHAR(100) NOT NULL,
    completed TINYINT(1) DEFAULT 0,
    completed_at DATETIME DEFAULT NULL,
    UNIQUE KEY unique_progress (user_id, course_id, lesson_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: user_courses
-- Description: Track purchased courses for each user
-- ============================================
CREATE TABLE user_courses (
    user_course_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    course_id VARCHAR(50) NOT NULL,
    purchased_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    progress INT DEFAULT 0,
    UNIQUE KEY unique_user_course (user_id, course_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_course_id (course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: teacher_courses
-- Description: Assign courses to teachers for management
-- ============================================
CREATE TABLE teacher_courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    teacher_id INT NOT NULL,
    course_id VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_teacher_course (teacher_id, course_id),
    FOREIGN KEY (teacher_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: assignments
-- Description: Store assignments created by teachers
-- ============================================
CREATE TABLE assignments (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id VARCHAR(50) NOT NULL,
    teacher_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATETIME DEFAULT NULL,
    max_score INT DEFAULT 100,
    is_active TINYINT(1) DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_course_id (course_id),
    INDEX idx_teacher_id (teacher_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: submissions
-- Description: Store student submissions for assignments
-- ============================================
CREATE TABLE submissions (
    submission_id INT PRIMARY KEY AUTO_INCREMENT,
    assignment_id INT NOT NULL,
    student_id INT NOT NULL,
    submission_content TEXT,
    file_path VARCHAR(500),
    score INT DEFAULT NULL,
    feedback TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    graded_at TIMESTAMP DEFAULT NULL,
    UNIQUE KEY unique_student_assignment (assignment_id, student_id),
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_student_id (student_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- INSERT SAMPLE DATA
-- ============================================

-- ============================================
-- Insert Users
-- ============================================
-- Password hashing: SHA-256 format
-- Format: email : password -> hash
-- All student passwords are: 123456
-- Admin password: admin123
-- Teacher passwords: teacher123

-- Password Hashes:
-- 123456 -> 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
-- admin123 -> 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
-- teacher123 -> cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416

INSERT INTO users (email, phone, password_hash, fullname) VALUES
-- System Accounts
('admin@ptit.edu.vn', NULL, '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Administrator'),

-- Teacher Accounts (6 teachers)
('teacher1@ptit.edu.vn', '0901234567', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Nguyen Van Python'),
('teacher2@ptit.edu.vn', '0901234568', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Tran Thi Finance'),
('teacher3@ptit.edu.vn', '0901234569', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Le Van Data'),
('teacher4@ptit.edu.vn', '0901234570', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Pham Thi Blockchain'),
('teacher5@ptit.edu.vn', '0901234571', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Hoang Van Accounting'),
('teacher6@ptit.edu.vn', '0901234572', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Vu Thi Marketing'),

-- Student Accounts (2 students for testing)
('tranduccuong17@gmail.com', '0123456789', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Trần Đức Cường'),
('student1@gmail.com', '0987654321', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Trần Thị Mai');

-- ============================================
-- Insert Courses (36 courses across 6 categories)
-- ============================================

-- Python Courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('python-procedural', 'Procedural Python - Lập trình hàm trong Python', 'python', 'Học lập trình hàm trong Python từ cơ bản đến nâng cao, áp dụng vào dự án thực tế', 1299000, 2499000, '12 giờ', 1234, 'Beginner', 'assets/img/Index/python.png', 1, 48),
('python-basics', 'Python Basics - Lập trình Python cơ bản', 'python', 'Khóa học Python cho người mới bắt đầu, từ zero đến hero', 999000, 1999000, '10 giờ', 2567, 'Beginner', 'assets/img/Index/python.png', 0, 50),
('python-complete', 'Python Toàn Tập - Từ Zero đến Hero', 'python', 'Khóa học Python toàn diện nhất, bao gồm tất cả kiến thức cần thiết', 2499000, 4999000, '40 giờ', 5678, 'All', 'assets/img/Index/python.png', 0, 50),
('python-excel', 'Python Excel cho người đi làm', 'python', 'Tự động hóa Excel bằng Python, tiết kiệm thời gian làm việc', 899000, 1799000, '8 giờ', 1890, 'Intermediate', 'assets/img/Index/python.png', 0, 50),
('selenium-python', 'Selenium Python - Test Automation', 'python', 'Automation testing với Selenium và Python', 1599000, 2999000, '18 giờ', 987, 'Advanced', 'assets/img/Index/python.png', 0, 47),
('python-oop', 'Python OOP - Lập trình hướng đối tượng', 'python', 'Lập trình hướng đối tượng với Python, từ cơ bản đến nâng cao', 1199000, 2399000, '14 giờ', 756, 'Intermediate', 'assets/img/Index/python.png', 0, 50);

-- Finance Courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('finance-basic', 'Tài chính cơ bản', 'finance', 'Học các khái niệm tài chính nền tảng, quản lý chi tiêu cá nhân hiệu quả', 799000, 1599000, '10 giờ', 2145, 'Beginner', 'assets/img/courses-finance/Tài chính cơ bản.png', 1, 50),
('investment', 'Đầu tư chứng khoán từ A-Z', 'finance', 'Phân tích và chiến lược đầu tư chứng khoán', 1699000, 3099000, '20 giờ', 3890, 'Intermediate', 'assets/img/courses-finance/Đầu tư chứng khoán.png', 1, 45),
('banking', 'Nghiệp vụ ngân hàng hiện đại', 'finance', 'Khóa học Nghiệp vụ Ngân hàng Thương mại từ TS Lê Thẩm Dương', 1299000, 2599000, '8.5 giờ', 1982, 'Intermediate', 'assets/img/courses-finance/Ngân hàng.png', 0, 50),
('personal-finance', 'Tài chính cá nhân thông minh', 'finance', 'Hành trình Tự do Tài chính từ A-Z', 699000, 1399000, '4.2 giờ', 2812, 'Beginner', 'assets/img/courses-finance/Tài chính cá nhân.png', 1, 50),
('forex', 'Trading Forex cho người mới', 'finance', 'Khóa học Trading Forex toàn diện từ fxalexg', 1599000, 2999000, '12 giờ', 2678, 'Advanced', 'assets/img/courses-finance/Forex.png', 0, 47),
('financial-analysis', 'Phân tích báo cáo tài chính', 'finance', 'Khóa học Phân tích báo cáo tài chính toàn diện', 1499000, 2999000, '7 giờ', 1876, 'Intermediate', 'assets/img/courses-finance/Phân tích tài chính.png', 0, 50);

-- Data Analyst Courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('data-basic', 'Data Analytics cơ bản', 'data', 'Khóa học phân tích dữ liệu cho người mới bắt đầu', 899000, 1799000, '12 giờ', 1567, 'Beginner', 'assets/img/Index/python.png', 1, 50),
('excel-data', 'Excel cho Data Analyst', 'data', 'Excel nâng cao cho phân tích dữ liệu', 799000, 1599000, '10 giờ', 2134, 'Beginner', 'assets/img/Index/python.png', 0, 50),
('sql-data', 'SQL cho Data Analyst', 'data', 'Học SQL từ cơ bản đến nâng cao cho Data Analyst', 1299000, 2599000, '16 giờ', 1876, 'Intermediate', 'assets/img/Index/python.png', 0, 50),
('power-bi', 'Power BI toàn tập', 'data', 'Trực quan hóa dữ liệu với Power BI', 1499000, 2999000, '18 giờ', 1654, 'Intermediate', 'assets/img/Index/python.png', 0, 50),
('python-data', 'Python cho Data Science', 'data', 'Python cho phân tích và khoa học dữ liệu', 1599000, 3199000, '20 giờ', 2234, 'Advanced', 'assets/img/Index/python.png', 0, 50),
('tableau', 'Tableau Desktop chuyên nghiệp', 'data', 'Trực quan hóa dữ liệu với Tableau', 1399000, 2799000, '16 giờ', 1423, 'Intermediate', 'assets/img/Index/python.png', 0, 50);

-- Blockchain Courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('blockchain-basic', 'Blockchain cơ bản', 'blockchain', 'Kiến thức nền tảng về công nghệ Blockchain', 1299000, 2599000, '14 giờ', 1234, 'Beginner', 'assets/img/Index/blockchian.png', 1, 50),
('smart-contract', 'Smart Contract với Solidity', 'blockchain', 'Lập trình Smart Contract trên Ethereum', 2099000, 4199000, '24 giờ', 876, 'Advanced', 'assets/img/Index/blockchian.png', 0, 50),
('defi', 'DeFi toàn tập', 'blockchain', 'Tài chính phi tập trung - DeFi từ A đến Z', 1799000, 3599000, '20 giờ', 1543, 'Intermediate', 'assets/img/Index/blockchian.png', 0, 50),
('nft', 'NFT và Metaverse', 'blockchain', 'NFT, Metaverse và tương lai của Web3', 1499000, 2999000, '16 giờ', 1876, 'Intermediate', 'assets/img/Index/blockchian.png', 0, 50),
('web3', 'Web3 Development', 'blockchain', 'Phát triển ứng dụng Web3 toàn diện', 2299000, 4599000, '28 giờ', 765, 'Advanced', 'assets/img/Index/blockchian.png', 0, 50),
('crypto-trading', 'Crypto Trading chuyên nghiệp', 'blockchain', 'Giao dịch tiền điện tử chuyên nghiệp', 1899000, 3799000, '22 giờ', 1234, 'Intermediate', 'assets/img/Index/blockchian.png', 0, 50);

-- Accounting Courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('accounting-basic', 'Kế toán cơ bản', 'accounting', 'Nguyên lý kế toán cho người mới bắt đầu', 699000, 1399000, '10 giờ', 2345, 'Beginner', 'assets/img/Index/kế toàn cơ bản.png', 1, 50),
('accounting-misa', 'Kế toán trên phần mềm MISA', 'accounting', 'Thực hành kế toán với phần mềm MISA', 1299000, 2599000, '16 giờ', 1876, 'Intermediate', 'assets/img/Index/kế toàn cơ bản.png', 0, 50),
('tax-accounting', 'Kế toán thuế', 'accounting', 'Kế toán thuế doanh nghiệp và cá nhân', 1499000, 2999000, '18 giờ', 1543, 'Intermediate', 'assets/img/Index/kế toàn cơ bản.png', 0, 50),
('cost-accounting', 'Kế toán chi phí', 'accounting', 'Kế toán và quản trị chi phí doanh nghiệp', 899000, 1799000, '12 giờ', 1234, 'Intermediate', 'assets/img/Index/kế toàn cơ bản.png', 0, 50),
('excel-accounting', 'Excel cho kế toán', 'accounting', 'Excel nâng cao cho nghề kế toán', 799000, 1599000, '10 giờ', 2134, 'Beginner', 'assets/img/Index/kế toàn cơ bản.png', 0, 50),
('financial-statements', 'Lập và phân tích báo cáo tài chính', 'accounting', 'Lập và phân tích báo cáo tài chính doanh nghiệp', 1399000, 2799000, '16 giờ', 1654, 'Advanced', 'assets/img/Index/kế toàn cơ bản.png', 0, 50);

-- Marketing Courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('digital-marketing', 'Digital Marketing toàn diện', 'marketing', 'Marketing kỹ thuật số từ A đến Z', 1499000, 2999000, '20 giờ', 3456, 'Beginner', 'assets/img/Index/combo sv kinh tế.png', 1, 50),
('facebook-ads', 'Facebook Ads chuyên nghiệp', 'marketing', 'Quảng cáo Facebook hiệu quả và tối ưu chi phí', 1299000, 2599000, '16 giờ', 2345, 'Intermediate', 'assets/img/Index/combo sv kinh tế.png', 0, 50),
('google-ads', 'Google Ads & SEO', 'marketing', 'Quảng cáo Google và tối ưu hóa công cụ tìm kiếm', 1599000, 3199000, '18 giờ', 2134, 'Intermediate', 'assets/img/Index/combo sv kinh tế.png', 0, 50),
('content-marketing', 'Content Marketing hiệu quả', 'marketing', 'Xây dựng chiến lược content marketing bài bản', 1199000, 2399000, '14 giờ', 1876, 'Intermediate', 'assets/img/Index/combo sv kinh tế.png', 0, 50),
('social-media', 'Social Media Marketing', 'marketing', 'Marketing trên các nền tảng mạng xã hội', 899000, 1799000, '12 giờ', 2567, 'Beginner', 'assets/img/Index/combo sv kinh tế.png', 0, 50),
('email-marketing', 'Email Marketing chuyên nghiệp', 'marketing', 'Chiến lược email marketing hiệu quả', 999000, 1999000, '10 giờ', 1654, 'Beginner', 'assets/img/Index/combo sv kinh tế.png', 0, 50);

-- ============================================
-- Insert Lessons for Finance Basic Course
-- ============================================
INSERT INTO lessons (course_id, section_id, lesson_title, lesson_content, video_url, duration, lesson_order, is_active) VALUES
('finance-basic', 1, 'LỘ TRÌNH XÂY DỰNG KIẾN THỨC TÀI CHÍNH', 'Nội dung bài học về lộ trình xây dựng kiến thức tài chính cơ bản', 'https://www.youtube.com/watch?v=madrRu_iU6U', '3:11', 1, 1),
('finance-basic', 1, 'BÀI 1: CÁC THUẬT NGỮ TÀI CHÍNH CƠ BẢN CẦN BIẾT', 'Giới thiệu các thuật ngữ tài chính cơ bản mà mọi người cần nắm vững', 'https://www.youtube.com/watch?v=wqcLaQo0m5s', '4:15', 2, 1),
('finance-basic', 1, 'BÀI 2: HIỂU VỀ THỊ TRƯỜNG TÀI CHÍNH', 'Khái niệm và cách thức hoạt động của thị trường tài chính', 'https://www.youtube.com/watch?v=i0-K4fAvlMQ', '5:03', 3, 1),
('finance-basic', 1, 'BÀI 3: BẢN CHẤT CỦA TÍCH LŨY TIỀN BẠC', 'Tìm hiểu về việc tích lũy tài sản và quản lý tiền bạc hiệu quả', 'https://www.youtube.com/watch?v=LBxgRZ04Fvc', '3:55', 4, 1),
('finance-basic', 1, 'BÀI 4: TÍCH LŨY TIỀN NHƯ THẾ NÀO ĐỂ ĐẠT ĐƯỢC HIỆU QUẢ NHẤT?', 'Các phương pháp và chiến lược tích lũy tiền hiệu quả', 'https://www.youtube.com/watch?v=LDV41AlayVw', '5:53', 5, 1),
('finance-basic', 1, 'BÀI 5: ĐẦU TƯ TỪ ĐÂU?', 'Hướng dẫn cơ bản về đầu tư tài chính từ khái niệm đến thực hành', 'https://www.youtube.com/watch?v=ULEMECVelP0', '6:28', 6, 1),
('finance-basic', 1, 'BÀI 6: PHÂN BIỆT CỔ PHIẾU VÀ TRÁI PHIẾU', 'Sự khác nhau giữa cổ phiếu và trái phiếu, ưu nhược điểm của từng loại', 'https://www.youtube.com/watch?v=EVPC25qboNA', '5:53', 7, 1),
('finance-basic', 1, 'BÀI 7: NÊN VỮNG LÝ THUYẾT RỒI MỚI ĐẦU TƯ HAY VỪA HỌC LÝ THUYẾT VỪA ĐẦU TƯ', 'Thảo luận về phương pháp học và thực hành đầu tư hiệu quả', 'https://www.youtube.com/watch?v=KiL4T9kYZDQ', '5:14', 8, 1),
('finance-basic', 1, 'BÀI 8: THẾ NÀO LÀ TIÊU TIỀN ĐÚNG ĐẮN?', 'Nguyên tắc tiêu dùng hợp lý và quản lý chi tiêu cá nhân', 'https://www.youtube.com/watch?v=dEXI-gGyAmI', '6:05', 9, 1),
('finance-basic', 1, 'BÀI 9: PHÁT TRIỂN CÁC CẤP ĐỘ TÀI CHÍNH ĐỂ TRỞ THÀNH NHÀ ĐẦU TƯ CHUYÊN NGHIỆP', 'Hướng dẫn phát triển kỹ năng đầu tư từ cơ bản đến chuyên nghiệp', 'https://www.youtube.com/watch?v=11erHIGnSPo', '5:03', 10, 1),
('finance-basic', 1, 'BÀI 10: 5 BÍ KÍP QUẢN LÝ TÀI CHÍNH SẼ THAY ĐỔI CUỘC SỐNG CỦA BẠN', '5 bí quyết quản lý tài chính hiệu quả thay đổi cuộc sống', 'https://www.youtube.com/watch?v=06yoYByxnrs', 'N/A', 11, 1),
('finance-basic', 1, 'BÀI 11: 5 KÊNH ĐẦU TƯ TÀI CHÍNH BẠN NÊN THỬ MỘT LẦN TRONG ĐỜI', 'Giới thiệu 5 kênh đầu tư tài chính phổ biến và hiệu quả', 'https://www.youtube.com/watch?v=FF8V1azhbaw', '7:53', 12, 1),
('finance-basic', 1, 'BÀI 12: CÁCH LẬP KẾ HOẠCH TÀI CHÍNH CÁ NHÂN TỪ CON SỐ 0 ĐẾN TỰ DO TÀI CHÍNH', 'Hướng dẫn lập kế hoạch tài chính cá nhân toàn diện', 'https://www.youtube.com/watch?v=M_maFKUUYbE', '8:46', 13, 1);

-- ============================================
-- Assign Courses to Teachers
-- ============================================
-- Assign all courses to all teachers
INSERT INTO teacher_courses (teacher_id, course_id) 
SELECT u.user_id, c.course_id 
FROM users u 
CROSS JOIN courses c 
WHERE u.email LIKE 'teacher%@ptit.edu.vn';

-- ============================================
-- Sample Data for Testing
-- ============================================

-- Sample Orders: Some students have purchased courses
INSERT INTO orders (user_id, total_amount, payment_method, status, created_at) VALUES
-- Student 1 purchased 2 courses
((SELECT user_id FROM users WHERE email = 'student1@gmail.com'), 2498000, 'bank', 'completed', '2025-10-15 10:30:00'),
-- Cuong purchased 1 course  
((SELECT user_id FROM users WHERE email = 'tranduccuong17@gmail.com'), 799000, 'cod', 'completed', '2025-11-01 14:20:00');

-- Order Items for above orders
INSERT INTO order_items (order_id, course_id, price) VALUES
-- Order 1: Student1 bought finance-basic and investment
(1, 'finance-basic', 799000),
(1, 'investment', 1699000),
-- Order 2: Cuong bought finance-basic
(2, 'finance-basic', 799000);

-- Sample Course Progress
INSERT INTO course_progress (user_id, course_id, progress_percentage, total_hours, status, last_accessed) VALUES
-- Student 1 progress
((SELECT user_id FROM users WHERE email = 'student1@gmail.com'), 'finance-basic', 75, 7.5, 'in_progress', '2025-11-20 15:30:00'),
((SELECT user_id FROM users WHERE email = 'student1@gmail.com'), 'investment', 20, 4.0, 'in_progress', '2025-11-19 10:20:00'),
-- Cuong progress
((SELECT user_id FROM users WHERE email = 'tranduccuong17@gmail.com'), 'finance-basic', 100, 10.0, 'completed', '2025-11-18 14:45:00');

-- ============================================
-- VERIFICATION QUERIES
-- ============================================
-- Run these queries to verify the data was inserted correctly:

-- SELECT COUNT(*) as user_count FROM users;
-- SELECT COUNT(*) as course_count FROM courses;
-- SELECT COUNT(*) as lesson_count FROM lessons WHERE course_id = 'finance-basic';
-- SELECT category, COUNT(*) as count FROM courses GROUP BY category;
-- SELECT * FROM users WHERE email LIKE '%@ptit.edu.vn';
-- SELECT * FROM orders;
-- SELECT o.order_id, u.fullname, c.course_name, oi.price 
-- FROM orders o 
-- JOIN users u ON o.user_id = u.user_id 
-- JOIN order_items oi ON o.order_id = oi.order_id 
-- JOIN courses c ON oi.course_id = c.course_id;
-- SELECT u.fullname, c.course_name, cp.progress_percentage, cp.status 
-- FROM course_progress cp 
-- JOIN users u ON cp.user_id = u.user_id 
-- JOIN courses c ON cp.course_id = c.course_id;


-- ============================================
-- NOTES & DOCUMENTATION
-- ============================================

-- ============================================
-- 1. USER ACCOUNTS (9 accounts total)
-- ============================================

-- SYSTEM ACCOUNTS:
-- Email: admin@ptit.edu.vn
-- Password: admin123
-- Role: Admin - Full system access

-- TEACHER ACCOUNTS (6 teachers):
-- Email: teacher1@ptit.edu.vn | Password: teacher123 | Name: Nguyen Van Python
-- Email: teacher2@ptit.edu.vn | Password: teacher123 | Name: Tran Thi Finance  
-- Email: teacher3@ptit.edu.vn | Password: teacher123 | Name: Le Van Data
-- Email: teacher4@ptit.edu.vn | Password: teacher123 | Name: Pham Thi Blockchain
-- Email: teacher5@ptit.edu.vn | Password: teacher123 | Name: Hoang Van Accounting
-- Email: teacher6@ptit.edu.vn | Password: teacher123 | Name: Vu Thi Marketing
-- Note: All teachers are assigned to ALL courses automatically

-- STUDENT ACCOUNTS (2 students):
-- Email: tranduccuong17@gmail.com | Password: 123456 | Name: Trần Đức Cường
-- Email: student1@gmail.com | Password: 123456 | Name: Trần Thị Mai

-- ============================================
-- 2. DATABASE CONTENT
-- ============================================
-- ✅ 36 Courses (6 categories × 6 courses each)
--    - Python (6 courses)
--    - Finance (6 courses)
--    - Data Analysis (6 courses)
--    - Blockchain (6 courses)
--    - Accounting (6 courses)
--    - Marketing (6 courses)
--
-- ✅ 13 Lessons for 'finance-basic' course
--    - All lessons have REAL YouTube video URLs
--    - Proper Vietnamese titles and content
--
-- ✅ 2 Sample Orders with 3 enrolled courses
--    - Student1: finance-basic (75% progress), investment (20% progress)
--    - Cuong: finance-basic (100% completed)
--
-- ✅ Course Progress tracking for enrolled students
--    - Percentage, hours, status (in_progress/completed)
--    - Last accessed timestamp

-- ============================================
-- 3. DATABASE FEATURES
-- ============================================
-- ✅ InnoDB engine for ACID transactions
-- ✅ Foreign keys with CASCADE DELETE for referential integrity
-- ✅ Indexes on frequently queried columns for performance
-- ✅ UTF8MB4 encoding for full Vietnamese support
-- ✅ Password hashing using SHA-256
-- ✅ Automatic timestamp tracking (created_at, updated_at)
-- ✅ Teacher-Course assignment system
-- ✅ Shopping cart and order management
-- ✅ Lesson and course progress tracking
-- ✅ Assignment and submission system

-- ============================================
-- 4. ACCESS CONTROL & PERMISSIONS
-- ============================================
-- ADMIN (@ptit.edu.vn):
--   - Full access to /admin dashboard
--   - Manage users, courses, and system settings
--   - View all analytics and reports

-- TEACHER (teacher*@ptit.edu.vn):
--   - Access to /teacher dashboard
--   - View enrolled students in their courses
--   - Create/edit lessons for assigned courses
--   - Create assignments and grade submissions
--   - Track student progress

-- STUDENTS:
--   - Browse and purchase courses
--   - Access learning materials for purchased courses
--   - Submit assignments
--   - Track personal progress

-- ============================================
-- 5. QUICK START GUIDE
-- ============================================
-- Step 1: Run this SQL file to create and populate database
--         mysql -u root -p < database_complete.sql

-- Step 2: Test accounts are ready to use:
--         - Login as teacher@ptit.edu.vn / teacher123
--         - Login as test@ptit.edu.vn / 123456

-- Step 3: Verify data with these queries:
SELECT COUNT(*) as total_users FROM users;
SELECT COUNT(*) as total_courses FROM courses;
SELECT COUNT(*) as total_lessons FROM lessons;
SELECT category, COUNT(*) as course_count FROM courses GROUP BY category;
SELECT u.email, u.fullname, COUNT(o.order_id) as orders 
FROM users u 
LEFT JOIN orders o ON u.user_id = o.user_id 
GROUP BY u.user_id;

-- Step 4: Check teacher assignments:
SELECT u.fullname as teacher, COUNT(tc.course_id) as assigned_courses
FROM users u
JOIN teacher_courses tc ON u.user_id = tc.teacher_id
GROUP BY u.user_id;

-- ============================================
-- END OF SCRIPT
-- Version: 2.0
-- Last Updated: 2025-11-22
-- ============================================

-- ============================================
-- Table: pending_changes
-- Description: Store pending changes that require admin approval
-- ============================================
CREATE TABLE IF NOT EXISTS pending_changes (
    change_id INT PRIMARY KEY AUTO_INCREMENT,
    teacher_id INT NOT NULL,
    change_type VARCHAR(50) NOT NULL,
    target_id VARCHAR(100),
    change_data TEXT,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_by INT,
    reviewed_at TIMESTAMP NULL,
    review_note TEXT,
    FOREIGN KEY (teacher_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_teacher_id (teacher_id),
    INDEX idx_status (status),
    INDEX idx_change_type (change_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- ============================================
