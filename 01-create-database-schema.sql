-- ============================================
-- PTIT LEARNING - CHUẨN DATABASE SCHEMA
-- Tạo cấu trúc database hoàn chỉnh
-- Encoding: UTF-8
-- ============================================

-- Xóa database cũ nếu tồn tại (Cẩn thận!)
-- DROP DATABASE IF EXISTS ptit_learning;

-- Tạo database mới với UTF-8
CREATE DATABASE IF NOT EXISTS ptit_learning 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE ptit_learning;

-- ============================================
-- Bảng: users - Quản lý tài khoản người dùng
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
-- Bảng: courses - Thông tin khóa học
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
    is_new BOOLEAN DEFAULT 0,
    discount_percentage INT DEFAULT 0,
    has_pending_changes BOOLEAN DEFAULT 0,
    last_modified_by INT,
    last_modified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    FOREIGN KEY (last_modified_by) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Bảng: cart - Giỏ hàng
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
-- Bảng: orders - Đơn hàng
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
-- Bảng: order_items - Chi tiết đơn hàng
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
-- Bảng: course_progress - Tiến độ học tập
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
-- Bảng: lessons - Bài học
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
    is_active BOOLEAN DEFAULT 1,
    has_pending_changes BOOLEAN DEFAULT 0,
    last_modified_by INT,
    last_modified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (last_modified_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_course_section (course_id, section_id),
    INDEX idx_lesson_order (lesson_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Bảng: lesson_progress - Tiến độ từng bài học
-- ============================================
CREATE TABLE lesson_progress (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    course_id VARCHAR(100) NOT NULL,
    lesson_id VARCHAR(100) NOT NULL,
    completed BOOLEAN DEFAULT 0,
    completed_at DATETIME DEFAULT NULL,
    UNIQUE KEY unique_progress (user_id, course_id, lesson_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Bảng: user_courses - Khóa học đã mua
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
-- Bảng: teacher_courses - Phân công giảng viên
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
-- Bảng: assignments - Bài tập
-- ============================================
CREATE TABLE assignments (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id VARCHAR(50) NOT NULL,
    teacher_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATETIME DEFAULT NULL,
    max_score INT DEFAULT 100,
    is_active BOOLEAN DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_course_id (course_id),
    INDEX idx_teacher_id (teacher_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Bảng: submissions - Bài nộp
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
-- Bảng: pending_changes - Thay đổi chờ duyệt
-- ============================================
CREATE TABLE pending_changes (
    change_id INT PRIMARY KEY AUTO_INCREMENT,
    table_name VARCHAR(50) NOT NULL,
    target_id VARCHAR(100) NOT NULL,
    change_type VARCHAR(20) NOT NULL,
    change_data TEXT NOT NULL,
    requested_by INT NOT NULL,
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'pending',
    reviewed_by INT DEFAULT NULL,
    reviewed_at TIMESTAMP NULL,
    review_note TEXT,
    FOREIGN KEY (requested_by) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_status (status),
    INDEX idx_table_target (table_name, target_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Bảng: payment_approval_history - Lịch sử duyệt thanh toán
-- ============================================
CREATE TABLE payment_approval_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    admin_id INT NOT NULL,
    action VARCHAR(20) NOT NULL,
    note TEXT,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (admin_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_order_id (order_id),
    INDEX idx_admin_id (admin_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- View: pending_changes_view - Xem thay đổi chờ duyệt
-- ============================================
CREATE OR REPLACE VIEW pending_changes_view AS
SELECT 
    pc.change_id,
    pc.table_name,
    pc.target_id,
    pc.change_type,
    pc.change_data,
    pc.status,
    pc.requested_at,
    pc.requested_at AS created_at,  -- Alias for backward compatibility
    pc.reviewed_at,
    pc.review_note,
    pc.requested_by AS teacher_id,  -- Alias for teacher queries
    pc.reviewed_by,
    u1.user_id AS requester_id,
    u1.fullname AS requester_name,
    u1.fullname AS teacher_name,     -- Alias for backward compatibility
    u1.email AS requester_email,
    u1.email AS teacher_email,       -- Alias for backward compatibility
    u2.fullname AS reviewer_name,
    u2.email AS reviewer_email,
    CASE 
        WHEN pc.table_name = 'courses' THEN c.course_name
        WHEN pc.table_name = 'lessons' THEN l.lesson_title
        ELSE NULL
    END AS item_name
FROM pending_changes pc
LEFT JOIN users u1 ON pc.requested_by = u1.user_id
LEFT JOIN users u2 ON pc.reviewed_by = u2.user_id
LEFT JOIN courses c ON pc.table_name = 'courses' AND pc.target_id = c.course_id
LEFT JOIN lessons l ON pc.table_name = 'lessons' AND pc.target_id = l.lesson_id
ORDER BY pc.requested_at DESC;

-- ============================================
-- Hoàn tất tạo schema
-- ============================================
SELECT 'Database schema created successfully!' AS status;
SELECT COUNT(*) AS total_tables FROM information_schema.tables WHERE table_schema = 'ptit_learning';
