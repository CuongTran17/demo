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
-- Description: Track user learning progress for each course
-- ============================================
CREATE TABLE IF NOT EXISTS course_progress (
    progress_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    course_id VARCHAR(50) NOT NULL,
    progress_percentage INT DEFAULT 0,
    total_hours DECIMAL(5,2) DEFAULT 0.00,
    last_accessed TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'in_progress',
    UNIQUE KEY unique_user_course_progress (user_id, course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Table: lessons
-- Description: Store lesson content for each course
-- ============================================
CREATE TABLE IF NOT EXISTS lessons (
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
CREATE TABLE IF NOT EXISTS lesson_progress (
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
CREATE TABLE IF NOT EXISTS user_courses (
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
CREATE TABLE IF NOT EXISTS teacher_courses (
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
CREATE TABLE IF NOT EXISTS assignments (
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
CREATE TABLE IF NOT EXISTS submissions (
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
-- Insert Sample Courses
-- ============================================

-- Python Courses (6 courses)
INSERT IGNORE INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('python-procedural', 'Procedural Python - Lập trình hàm trong Python', 'python', 'Học lập trình hàm trong Python từ cơ bản đến nâng cao, áp dụng vào dự án thực tế', 1299000, 2499000, '12 giờ', 1234, 'Beginner', 1, 48),
('python-basics', 'Python Basics - Lập trình Python cơ bản', 'python', 'Khóa học Python cho người mới bắt đầu, từ zero đến hero', 999000, 1999000, '10 giờ', 2567, 'Beginner', 0, 50),
('python-complete', 'Python Toàn Tập - Từ Zero đến Hero', 'python', 'Khóa học Python toàn diện nhất, bao gồm tất cả kiến thức cần thiết', 2499000, 4999000, '40 giờ', 5678, 'All', 0, 50),
('python-excel', 'Python Excel cho người đi làm', 'python', 'Tự động hóa Excel bằng Python, tiết kiệm thời gian làm việc', 899000, 1799000, '8 giờ', 1890, 'Intermediate', 0, 50),
('selenium-python', 'Selenium Python - Test Automation', 'python', 'Automation testing với Selenium và Python', 1599000, 2999000, '18 giờ', 987, 'Advanced', 0, 47),
('python-oop', 'Python OOP - Lập trình hướng đối tượng', 'python', 'Lập trình hướng đối tượng với Python, từ cơ bản đến nâng cao', 1199000, 2399000, '14 giờ', 756, 'Intermediate', 0, 50);

-- Finance Courses (6 courses)
INSERT IGNORE INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('finance-basic', 'Tài chính cơ bản', 'finance', 'Kiến thức nền tảng tài chính cho người mới bắt đầu', 799000, 1599000, '10 giờ', 2345, 'Beginner', 1, 50),
('investment', 'Đầu tư chứng khoán từ A-Z', 'finance', 'Phân tích và chiến lược đầu tư chứng khoán', 1699000, 3099000, '20 giờ', 3890, 'Intermediate', 1, 45),
('banking', 'Nghiệp vụ ngân hàng hiện đại', 'finance', 'Khóa học Nghiệp vụ Ngân hàng Thương mại từ TS Lê Thẩm Dương - Từ lý thuyết cơ bản đến nghiệp vụ tín dụng chuyên sâu', 1299000, 2599000, '8.5 giờ', 1982, 'Intermediate', 0, 50),
('personal-finance', 'Tài chính cá nhân thông minh', 'finance', 'Hành trình Tự do Tài chính từ A-Z - Series đầy đủ từ Hieu Nguyen về quản lý tài chính, đầu tư và xây dựng thu nhập thụ động', 699000, 1399000, '4.2 giờ', 2812, 'Beginner', 1, 50),
('forex', 'Trading Forex cho người mới', 'finance', 'Khóa học Trading Forex toàn diện từ fxalexg - 22 video hướng dẫn từ cơ bản đến chuyên nghiệp, bao gồm chiến lược swing trading, day trading, quản lý rủi ro và tăng trưởng tài khoản', 1599000, 2999000, '12 giờ', 2678, 'Advanced', 0, 47),
('financial-analysis', 'Phân tích báo cáo tài chính', 'finance', 'Khóa học Phân tích báo cáo tài chính toàn diện từ Ths. Võ Minh Long - 7 video chuyên sâu về cách đọc, phân tích bảng cân đối kế toán, báo cáo lưu chuyển tiền tệ, tỷ số tài chính và case study thực tế', 1499000, 2999000, '7 giờ', 1876, 'Intermediate', 0, 50);

-- Data Analyst Courses (6 courses)
INSERT IGNORE INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('data-basic', 'Data Analytics cơ bản', 'data', 'Khóa học phân tích dữ liệu cho người mới bắt đầu', 899000, 1799000, '12 giờ', 1567, 'Beginner', 1, 50),
('excel-data', 'Excel cho Data Analyst', 'data', 'Excel nâng cao cho phân tích dữ liệu', 799000, 1599000, '10 giờ', 2134, 'Beginner', 0, 50),
('sql-data', 'SQL cho Data Analyst', 'data', 'Học SQL từ cơ bản đến nâng cao cho Data Analyst', 1299000, 2599000, '16 giờ', 1876, 'Intermediate', 0, 50),
('power-bi', 'Power BI toàn tập', 'data', 'Trực quan hóa dữ liệu với Power BI', 1499000, 2999000, '18 giờ', 1654, 'Intermediate', 0, 50),
('python-data', 'Python cho Data Science', 'data', 'Python cho phân tích và khoa học dữ liệu', 1599000, 3199000, '20 giờ', 2234, 'Advanced', 0, 50),
('tableau', 'Tableau Desktop chuyên nghiệp', 'data', 'Trực quan hóa dữ liệu với Tableau', 1399000, 2799000, '16 giờ', 1423, 'Intermediate', 0, 50);

-- Blockchain Courses (6 courses)
INSERT IGNORE INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('blockchain-basic', 'Blockchain cơ bản', 'blockchain', 'Kiến thức nền tảng về công nghệ Blockchain', 1299000, 2599000, '14 giờ', 1234, 'Beginner', 1, 50),
('smart-contract', 'Smart Contract với Solidity', 'blockchain', 'Lập trình Smart Contract trên Ethereum', 2099000, 4199000, '24 giờ', 876, 'Advanced', 0, 50),
('defi', 'DeFi toàn tập', 'blockchain', 'Tài chính phi tập trung - DeFi từ A đến Z', 1799000, 3599000, '20 giờ', 1543, 'Intermediate', 0, 50),
('nft', 'NFT và Metaverse', 'blockchain', 'NFT, Metaverse và tương lai của Web3', 1499000, 2999000, '16 giờ', 1876, 'Intermediate', 0, 50),
('web3', 'Web3 Development', 'blockchain', 'Phát triển ứng dụng Web3 toàn diện', 2299000, 4599000, '28 giờ', 765, 'Advanced', 0, 50),
('crypto-trading', 'Crypto Trading chuyên nghiệp', 'blockchain', 'Giao dịch tiền điện tử chuyên nghiệp', 1899000, 3799000, '22 giờ', 1234, 'Intermediate', 0, 50);

-- Accounting Courses (6 courses)
INSERT IGNORE INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('accounting-basic', 'Kế toán cơ bản', 'accounting', 'Nguyên lý kế toán cho người mới bắt đầu', 699000, 1399000, '10 giờ', 2345, 'Beginner', 1, 50),
('accounting-misa', 'Kế toán trên phần mềm MISA', 'accounting', 'Thực hành kế toán với phần mềm MISA', 1299000, 2599000, '16 giờ', 1876, 'Intermediate', 0, 50),
('tax-accounting', 'Kế toán thuế', 'accounting', 'Kế toán thuế doanh nghiệp và cá nhân', 1499000, 2999000, '18 giờ', 1543, 'Intermediate', 0, 50),
('cost-accounting', 'Kế toán chi phí', 'accounting', 'Kế toán và quản trị chi phí doanh nghiệp', 899000, 1799000, '12 giờ', 1234, 'Intermediate', 0, 50),
('excel-accounting', 'Excel cho kế toán', 'accounting', 'Excel nâng cao cho nghề kế toán', 799000, 1599000, '10 giờ', 2134, 'Beginner', 0, 50),
('financial-statements', 'Lập và phân tích báo cáo tài chính', 'accounting', 'Lập và phân tích báo cáo tài chính doanh nghiệp', 1399000, 2799000, '16 giờ', 1654, 'Advanced', 0, 50);

-- Marketing Courses (6 courses)
INSERT IGNORE INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('digital-marketing', 'Digital Marketing toàn diện', 'marketing', 'Marketing kỹ thuật số từ A đến Z', 1499000, 2999000, '20 giờ', 3456, 'Beginner', 1, 50),
('facebook-ads', 'Facebook Ads chuyên nghiệp', 'marketing', 'Quảng cáo Facebook hiệu quả và tối ưu chi phí', 1299000, 2599000, '16 giờ', 2345, 'Intermediate', 0, 50),
('google-ads', 'Google Ads & SEO', 'marketing', 'Quảng cáo Google và tối ưu hóa công cụ tìm kiếm', 1599000, 3199000, '18 giờ', 2134, 'Intermediate', 0, 50),
('content-marketing', 'Content Marketing hiệu quả', 'marketing', 'Xây dựng chiến lược content marketing bài bản', 1199000, 2399000, '14 giờ', 1876, 'Intermediate', 0, 50),
('social-media', 'Social Media Marketing', 'marketing', 'Marketing trên các nền tảng mạng xã hội', 899000, 1799000, '12 giờ', 2567, 'Beginner', 0, 50),
('email-marketing', 'Email Marketing chuyên nghiệp', 'marketing', 'Chiến lược email marketing hiệu quả', 999000, 1999000, '10 giờ', 1654, 'Beginner', 0, 50);

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
-- 1. Default user accounts:
--    Test User:
--      Email: test@ptit.edu.vn
--      Password: 123456
--    
--    Admin Account:
--      Email: admin@ptit.edu.vn
--      Password: admin123
--    
--    Teacher Account:
--      Email: teacher@ptit.edu.vn
--      Password: teacher123
--
-- 2. Sample data includes:
--    - 36 courses across 6 categories (Python, Finance, Data, Blockchain, Accounting, Marketing)
--    - 1 test user with purchased courses
--    - Course progress tracking system
--    - Teacher-course assignment system
--
-- 3. Database features:
--    - All tables use InnoDB engine for transaction support
--    - Foreign keys with CASCADE DELETE ensure referential integrity
--    - Indexes added for performance optimization on frequently queried columns
--    - UTF8MB4 encoding supports full Unicode including emojis
--
-- 4. Progress tracking:
--    - lesson_progress: Tracks individual lesson completions (completed = 0/1)
--    - course_progress: Aggregates overall progress_percentage and total_hours
--    - Automatic progress calculation via LessonProgressServlet
--
-- 5. Access control:
--    - Admin: Can access /admin for user/teacher/course management
--    - Teacher: Can access /teacher for student progress tracking
--    - Students: Can access courses, cart, orders, learning pages
--
-- 6. Assignment system:
--    - Teachers create assignments for their assigned courses
--    - Students submit assignments with content/files
--    - Teachers grade submissions and provide feedback

-- ============================================
-- Update course thumbnails with actual image paths
-- ============================================
UPDATE courses SET thumbnail = 'assets/img/Index/python.png' WHERE category = 'python';
UPDATE courses SET thumbnail = 'assets/img/courses-finance/Tài chính cơ bản.png' WHERE course_id = 'finance-basic';
UPDATE courses SET thumbnail = 'assets/img/courses-finance/Đầu tư chứng khoán.png' WHERE course_id = 'investment';
UPDATE courses SET thumbnail = 'assets/img/courses-finance/Ngân hàng.png' WHERE course_id = 'banking';
UPDATE courses SET thumbnail = 'assets/img/courses-finance/Tài chính cá nhân.png' WHERE course_id = 'personal-finance';
UPDATE courses SET thumbnail = 'assets/img/courses-finance/Forex.png' WHERE course_id = 'forex';
UPDATE courses SET thumbnail = 'assets/img/courses-finance/Phân tích tài chính.png' WHERE course_id = 'financial-analysis';
UPDATE courses SET thumbnail = 'assets/img/Index/python.png' WHERE category = 'data';
UPDATE courses SET thumbnail = 'assets/img/Index/blockchian.png' WHERE category = 'blockchain';
UPDATE courses SET thumbnail = 'assets/img/Index/kế toàn cơ bản.png' WHERE category = 'accounting';
UPDATE courses SET thumbnail = 'assets/img/Index/combo sv kinh tế.png' WHERE category = 'marketing';
-- ============================================
