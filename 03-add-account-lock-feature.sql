-- ============================================
-- PTIT LEARNING - THÊM CHỨC NĂNG KHÓA TÀI KHOẢN
-- Cập nhật database schema để hỗ trợ khóa tài khoản
-- Encoding: UTF-8
-- ============================================

USE ptit_learning;

-- ============================================
-- Cập nhật bảng users - Thêm trường khóa tài khoản
-- ============================================
ALTER TABLE users 
ADD COLUMN is_locked BOOLEAN DEFAULT 0 COMMENT 'Trạng thái khóa tài khoản: 0=Bình thường, 1=Bị khóa',
ADD COLUMN locked_reason TEXT COMMENT 'Lý do khóa tài khoản',
ADD COLUMN locked_by INT COMMENT 'ID người thực hiện khóa',
ADD COLUMN locked_at TIMESTAMP NULL COMMENT 'Thời gian khóa tài khoản',
ADD INDEX idx_is_locked (is_locked);

-- Thêm khóa ngoại cho locked_by
ALTER TABLE users
ADD CONSTRAINT fk_users_locked_by FOREIGN KEY (locked_by) REFERENCES users(user_id) ON DELETE SET NULL;

-- ============================================
-- Bảng: account_lock_requests - Yêu cầu khóa tài khoản từ giáo viên
-- ============================================
CREATE TABLE account_lock_requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT,
    target_user_id INT NOT NULL COMMENT 'ID tài khoản cần khóa',
    requester_id INT NOT NULL COMMENT 'ID giáo viên yêu cầu khóa',
    reason TEXT NOT NULL COMMENT 'Lý do yêu cầu khóa tài khoản',
    request_type ENUM('lock', 'unlock') DEFAULT 'lock' COMMENT 'Loại yêu cầu: khóa hoặc mở khóa',
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending' COMMENT 'Trạng thái yêu cầu',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời gian tạo yêu cầu',
    reviewed_by INT COMMENT 'ID admin duyệt yêu cầu',
    reviewed_at TIMESTAMP NULL COMMENT 'Thời gian duyệt yêu cầu',
    review_note TEXT COMMENT 'Ghi chú của admin khi duyệt',
    FOREIGN KEY (target_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (requester_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_target_user (target_user_id),
    INDEX idx_requester (requester_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- View: account_lock_requests_view - Xem chi tiết yêu cầu khóa tài khoản
-- ============================================
CREATE OR REPLACE VIEW account_lock_requests_view AS
SELECT 
    alr.request_id,
    alr.target_user_id,
    alr.requester_id,
    alr.reason,
    alr.request_type,
    alr.status,
    alr.created_at,
    alr.reviewed_by,
    alr.reviewed_at,
    alr.review_note,
    u_target.fullname AS target_fullname,
    u_target.email AS target_email,
    u_target.phone AS target_phone,
    u_target.is_locked AS target_is_locked,
    u_requester.fullname AS requester_fullname,
    u_requester.email AS requester_email,
    u_reviewer.fullname AS reviewer_fullname,
    u_reviewer.email AS reviewer_email
FROM account_lock_requests alr
LEFT JOIN users u_target ON alr.target_user_id = u_target.user_id
LEFT JOIN users u_requester ON alr.requester_id = u_requester.user_id
LEFT JOIN users u_reviewer ON alr.reviewed_by = u_reviewer.user_id
ORDER BY alr.created_at DESC;

-- ============================================
-- Hoàn tất cập nhật
-- ============================================
SELECT 'Account lock feature added successfully!' AS status;
