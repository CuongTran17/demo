USE ptit_learning;
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET foreign_key_checks = 0;

TRUNCATE TABLE course_progress;
TRUNCATE TABLE order_items;
TRUNCATE TABLE orders;
TRUNCATE TABLE cart;

DROP TABLE IF EXISTS courses;

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

INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('python-procedural', 'Procedural Python - Lập trình hàm trong Python', 'python', 'Học lập trình hàm trong Python từ cơ bản đến nâng cao', 1299000, 2499000, '12 giờ', 1234, 'Beginner', 1, 48),
('python-basics', 'Python Basics - Lập trình Python cơ bản', 'python', 'Khóa học Python cho người mới bắt đầu', 999000, 1999000, '10 giờ', 2567, 'Beginner', 0, 50),
('python-complete', 'Python Toàn Tập - Từ Zero đến Hero', 'python', 'Khóa học Python toàn diện nhất', 2499000, 4999000, '40 giờ', 5678, 'All', 0, 50),
('python-excel', 'Python Excel cho người đi làm', 'python', 'Tự động hóa Excel bằng Python', 899000, 1799000, '8 giờ', 1890, 'Intermediate', 0, 50),
('selenium-python', 'Selenium Python - Test Automation', 'python', 'Automation testing với Selenium và Python', 1599000, 2999000, '18 giờ', 987, 'Advanced', 0, 47),
('python-oop', 'Python OOP - Lập trình hướng đối tượng', 'python', 'Lập trình hướng đối tượng với Python', 1199000, 2399000, '14 giờ', 756, 'Intermediate', 0, 50);

INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('finance-basic', 'Tài chính cơ bản', 'finance', 'Kiến thức nền tảng tài chính cho người mới', 799000, 1599000, '10 giờ', 2345, 'Beginner', 1, 50),
('investment', 'Đầu tư chứng khoán từ A-Z', 'finance', 'Phân tích và chiến lược đầu tư', 1699000, 3099000, '20 giờ', 3890, 'Intermediate', 1, 45),
('banking', 'Nghiệp vụ ngân hàng hiện đại', 'finance', 'Nghiệp vụ Ngân hàng Thương mại', 1299000, 2599000, '8.5 giờ', 1982, 'Intermediate', 0, 50),
('personal-finance', 'Quản lý tài chính cá nhân thông minh', 'finance', 'Hành trình Tự do Tài chính', 699000, 1399000, '4.2 giờ', 2812, 'Beginner', 1, 50),
('forex', 'Trading Forex cho người mới', 'finance', 'Trading Forex toàn diện', 1599000, 2999000, '12 giờ', 2678, 'Advanced', 0, 47),
('financial-analysis', 'Phân tích báo cáo tài chính', 'finance', 'Phân tích báo cáo tài chính toàn diện', 1499000, 2999000, '7 giờ', 1876, 'Intermediate', 0, 50);

SET foreign_key_checks = 1;