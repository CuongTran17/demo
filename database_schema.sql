-- ============================================
-- PTIT LEARNING - Database Schema
-- ============================================

-- Create database
CREATE DATABASE IF NOT EXISTS ptit_learning 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE ptit_learning;

-- ============================================
-- Table: users
-- Description: Store user accounts
-- ============================================
CREATE TABLE IF NOT EXISTS users (
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
CREATE TABLE IF NOT EXISTS courses (
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
CREATE TABLE IF NOT EXISTS cart (
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
CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
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
CREATE TABLE IF NOT EXISTS order_items (
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
-- Description: Track user learning progress
-- ============================================
CREATE TABLE IF NOT EXISTS course_progress (
    progress_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    course_id VARCHAR(50) NOT NULL,
    progress_percentage INT DEFAULT 0,
    total_hours DECIMAL(5,2) DEFAULT 0.00,
    last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'in_progress',
    UNIQUE KEY unique_user_course_progress (user_id, course_id),
    INDEX idx_user_id (user_id),
    INDEX idx_course_id (course_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Insert Sample Courses
-- ============================================

-- Python Courses
INSERT IGNORE INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('python-basics', 'Python Basics', 'python', 'Khóa học Python cơ bản cho người mới bắt đầu', 999000, 1499000, '40 giờ', 1250, 'Beginner', 1, 33),
('python-advanced', 'Python Advanced', 'python', 'Khóa học Python nâng cao', 1299000, 1999000, '60 giờ', 850, 'Advanced', 0, 35),
('python-oop', 'Object-Oriented Python', 'python', 'Lập trình hướng đối tượng với Python', 1199000, 1799000, '50 giờ', 920, 'Intermediate', 0, 33),
('python-web', 'Python Web Development', 'python', 'Phát triển web với Python và Django', 1499000, 2299000, '80 giờ', 760, 'Advanced', 1, 35),
('python-data', 'Python for Data Science', 'python', 'Python cho Data Science', 1399000, 2099000, '70 giờ', 680, 'Intermediate', 0, 33),
('python-procedural', 'Procedural Python', 'python', 'Lập trình thủ tục với Python', 1299000, NULL, '55 giờ', 540, 'Intermediate', 0, 0);

-- Finance Courses
INSERT IGNORE INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('finance-basic', 'Finance Basics', 'finance', 'Kiến thức tài chính cơ bản', 1299000, 1999000, '45 giờ', 980, 'Beginner', 0, 35),
('finance-investment', 'Investment Strategies', 'finance', 'Chiến lược đầu tư hiệu quả', 1599000, 2499000, '65 giờ', 720, 'Intermediate', 1, 36),
('finance-personal', 'Personal Finance', 'finance', 'Quản lý tài chính cá nhân', 1199000, 1799000, '40 giờ', 1100, 'Beginner', 0, 33);

-- Data Analyst Courses
INSERT IGNORE INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('data-analysis', 'Data Analysis Fundamentals', 'data', 'Phân tích dữ liệu cơ bản', 1399000, 2099000, '55 giờ', 820, 'Beginner', 0, 33),
('data-visualization', 'Data Visualization', 'data', 'Trực quan hóa dữ liệu', 1299000, 1999000, '50 giờ', 740, 'Intermediate', 1, 35);

-- Blockchain Courses
INSERT IGNORE INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('blockchain-basics', 'Blockchain Fundamentals', 'blockchain', 'Kiến thức cơ bản về Blockchain', 1499000, 2299000, '60 giờ', 650, 'Beginner', 1, 35),
('smart-contracts', 'Smart Contract Development', 'blockchain', 'Phát triển Smart Contract', 1799000, 2799000, '75 giờ', 480, 'Advanced', 0, 36);

-- Accounting Courses
INSERT IGNORE INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('accounting-basic', 'Accounting Basics', 'accounting', 'Kế toán cơ bản', 1199000, 1799000, '45 giờ', 890, 'Beginner', 0, 33),
('accounting-advanced', 'Advanced Accounting', 'accounting', 'Kế toán nâng cao', 1499000, 2299000, '70 giờ', 560, 'Advanced', 0, 35);

-- Marketing Courses
INSERT IGNORE INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('marketing-digital', 'Digital Marketing', 'marketing', 'Marketing kỹ thuật số', 1399000, 2099000, '55 giờ', 1020, 'Beginner', 1, 33),
('marketing-social', 'Social Media Marketing', 'marketing', 'Marketing trên mạng xã hội', 1299000, 1999000, '50 giờ', 880, 'Intermediate', 0, 35);

-- ============================================
-- Insert Sample User (for testing)
-- Password: 123456 (SHA-256 hashed)
-- ============================================
INSERT INTO users (email, phone, password_hash, fullname) VALUES
('test@ptit.edu.vn', '0123456789', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Nguyen Van Test')
ON DUPLICATE KEY UPDATE email=email;

-- ============================================
-- Insert Sample Orders (for testing with user_id = 1)
-- Note: Run this manually if you want sample order data
-- ============================================
-- INSERT IGNORE INTO orders (user_id, total_amount, payment_method, status, created_at) VALUES
-- (1, 2298000, 'cod', 'completed', '2025-10-15 10:30:00'),
-- (1, 1299000, 'bank', 'completed', '2025-11-01 14:20:00');

-- Get the order IDs and insert order items manually:
-- SET @order1 = (SELECT order_id FROM orders WHERE user_id = 1 ORDER BY created_at LIMIT 1);
-- SET @order2 = (SELECT order_id FROM orders WHERE user_id = 1 ORDER BY created_at DESC LIMIT 1);

-- INSERT IGNORE INTO order_items (order_id, course_id, price) VALUES
-- (@order1, 'python-basics', 999000),
-- (@order1, 'finance-basic', 1299000),
-- (@order2, 'python-advanced', 1299000);

-- ============================================
-- Insert Sample Course Progress (for testing)
-- Note: Run this manually if you want sample progress data
-- ============================================
-- INSERT IGNORE INTO course_progress (user_id, course_id, progress_percentage, total_hours, status) VALUES
-- (1, 'python-basics', 75, 30.5, 'in_progress'),
-- (1, 'finance-basic', 100, 45.0, 'completed'),
-- (1, 'python-advanced', 25, 15.0, 'in_progress');

-- ============================================
-- NOTES:
-- ============================================
-- 1. Default test user credentials:
--    Email: test@ptit.edu.vn
--    Password: 123456
--
-- 2. Sample data includes:
--    - 18 courses across 6 categories
--    - 1 test user with 3 purchased courses
--    - 2 completed orders
--    - Course progress tracking
--
-- 3. All tables use InnoDB engine for transaction support
-- 4. Foreign keys ensure referential integrity
-- 5. Indexes added for performance optimization
-- ============================================
