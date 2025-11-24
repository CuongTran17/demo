-- ============================================
-- PTIT LEARNING - Approval System
-- Hệ thống phê duyệt thay đổi từ giáo viên
-- ============================================

USE ptit_learning;

-- Tạo bảng lưu các thay đổi chờ phê duyệt
CREATE TABLE IF NOT EXISTS pending_changes (
    change_id INT PRIMARY KEY AUTO_INCREMENT,
    teacher_id INT NOT NULL,
    change_type VARCHAR(50) NOT NULL, -- 'course_update', 'lesson_create', 'lesson_update', 'lesson_delete'
    target_id VARCHAR(100) NOT NULL,  -- course_id hoặc lesson_id
    change_data JSON NOT NULL,        -- Dữ liệu thay đổi ở dạng JSON
    status VARCHAR(20) DEFAULT 'pending', -- 'pending', 'approved', 'rejected'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP NULL,
    reviewed_by INT NULL,
    review_note TEXT NULL,
    FOREIGN KEY (teacher_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_status (status),
    INDEX idx_teacher (teacher_id),
    INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Thêm cột để đánh dấu courses/lessons đang chờ review
-- Kiểm tra và thêm từng cột riêng lẻ
SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'ptit_learning' AND TABLE_NAME = 'courses' AND COLUMN_NAME = 'has_pending_changes');
SET @sqlstmt := IF(@exist = 0, 'ALTER TABLE courses ADD COLUMN has_pending_changes TINYINT(1) DEFAULT 0', 'SELECT "Column exists"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'ptit_learning' AND TABLE_NAME = 'courses' AND COLUMN_NAME = 'last_modified_by');
SET @sqlstmt := IF(@exist = 0, 'ALTER TABLE courses ADD COLUMN last_modified_by INT NULL', 'SELECT "Column exists"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'ptit_learning' AND TABLE_NAME = 'courses' AND COLUMN_NAME = 'last_modified_at');
SET @sqlstmt := IF(@exist = 0, 'ALTER TABLE courses ADD COLUMN last_modified_at TIMESTAMP NULL', 'SELECT "Column exists"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

-- Tương tự cho lessons
SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'ptit_learning' AND TABLE_NAME = 'lessons' AND COLUMN_NAME = 'has_pending_changes');
SET @sqlstmt := IF(@exist = 0, 'ALTER TABLE lessons ADD COLUMN has_pending_changes TINYINT(1) DEFAULT 0', 'SELECT "Column exists"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'ptit_learning' AND TABLE_NAME = 'lessons' AND COLUMN_NAME = 'last_modified_by');
SET @sqlstmt := IF(@exist = 0, 'ALTER TABLE lessons ADD COLUMN last_modified_by INT NULL', 'SELECT "Column exists"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS 
    WHERE TABLE_SCHEMA = 'ptit_learning' AND TABLE_NAME = 'lessons' AND COLUMN_NAME = 'last_modified_at');
SET @sqlstmt := IF(@exist = 0, 'ALTER TABLE lessons ADD COLUMN last_modified_at TIMESTAMP NULL', 'SELECT "Column exists"');
PREPARE stmt FROM @sqlstmt;
EXECUTE stmt;

-- Tạo view để xem các thay đổi chờ duyệt với thông tin đầy đủ
CREATE OR REPLACE VIEW pending_changes_view AS
SELECT 
    pc.change_id,
    pc.teacher_id,
    t.fullname as teacher_name,
    t.email as teacher_email,
    pc.change_type,
    pc.target_id,
    pc.change_data,
    pc.status,
    pc.created_at,
    pc.reviewed_at,
    pc.reviewed_by,
    a.fullname as reviewer_name,
    pc.review_note
FROM pending_changes pc
JOIN users t ON pc.teacher_id = t.user_id
LEFT JOIN users a ON pc.reviewed_by = a.user_id
ORDER BY pc.created_at DESC;

-- Insert sample data để test (optional)
-- INSERT INTO pending_changes (teacher_id, change_type, target_id, change_data) VALUES
-- (7, 'course_update', 'python-basics', '{"course_name": "Python Basics - Updated", "description": "New description"}');

SELECT 'Approval system tables created successfully!' as message;
