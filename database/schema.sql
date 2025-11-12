-- PTIT Learning Database Schema
-- MySQL 8.0+

CREATE DATABASE IF NOT EXISTS ptit_learning CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ptit_learning;

-- Users table
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

-- Courses table
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
    is_new BOOLEAN DEFAULT FALSE,
    discount_percentage INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category (category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Order items table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    course_id VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    INDEX idx_order (order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- User purchased courses table
CREATE TABLE user_courses (
    user_course_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    course_id VARCHAR(50) NOT NULL,
    purchased_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    progress INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_course (user_id, course_id),
    INDEX idx_user (user_id),
    INDEX idx_course (course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample courses (Python)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('python-procedural', 'Procedural Python', 'python', 'Học lập trình Python theo phong cách thủ tục, nền tảng vững chắc cho người mới', 1299000, 2499000, '15 giờ', 3542, 'Cơ bản', TRUE, 50),
('python-basics', 'Python Basics', 'python', 'Khóa học Python cơ bản từ A-Z cho người mới bắt đầu', 999000, 1999000, '12 giờ', 4231, 'Cơ bản', FALSE, 50),
('python-oop', 'Python OOP', 'python', 'Lập trình hướng đối tượng với Python, nâng cao kỹ năng thiết kế', 1499000, NULL, '18 giờ', 2156, 'Trung cấp', FALSE, 0),
('python-advanced', 'Advanced Python', 'python', 'Kỹ thuật Python nâng cao: decorators, generators, async/await', 1799000, NULL, '20 giờ', 1842, 'Nâng cao', FALSE, 0),
('python-data-science', 'Python for Data Science', 'python', 'Python cho Data Science với NumPy, Pandas, Matplotlib', 1699000, 2999000, '22 giờ', 3891, 'Trung cấp', FALSE, 40),
('python-web-django', 'Web Development with Django', 'python', 'Xây dựng ứng dụng web với Django framework', 1899000, NULL, '25 giờ', 2743, 'Trung cấp', FALSE, 0);

-- Insert sample courses (Finance)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('finance-basic', 'Tài chính cơ bản cho người mới bắt đầu', 'finance', 'Học các khái niệm tài chính nền tảng, quản lý chi tiêu cá nhân hiệu quả', 899000, 1799000, '10 giờ', 2145, 'Cơ bản', TRUE, 50),
('finance-investment', 'Đầu tư chứng khoán', 'finance', 'Hướng dẫn đầu tư chứng khoán từ cơ bản đến nâng cao', 1299000, 2299000, '15 giờ', 3567, 'Trung cấp', FALSE, 45),
('finance-personal', 'Quản lý tài chính cá nhân', 'finance', 'Lập kế hoạch tài chính, tiết kiệm và đầu tư hiệu quả', 799000, NULL, '8 giờ', 4532, 'Cơ bản', FALSE, 0);

-- Create default admin user (password: admin123)
-- Hash using SHA-256: 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
INSERT INTO users (email, phone, password_hash, fullname) VALUES
('admin@ptit.edu.vn', '0123456789', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Administrator');
