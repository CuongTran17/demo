-- ============================================
-- PTIT LEARNING - Sample Data
-- Insert Sample Data for Testing
-- ============================================
-- Run this file AFTER create-tables.sql
-- ============================================

USE ptit_learning;

-- ============================================
-- Insert Admin Account
-- ============================================
-- Password: admin123 (SHA-256 hashed)
INSERT IGNORE INTO users (email, password, fullname, phone, role) VALUES
('admin@ptit.edu.vn', 'SHA2("admin123", 256)', 'Administrator', '0999999999', 'admin');

-- ============================================
-- Insert Teacher Accounts
-- ============================================
-- Password: teacher123 (SHA-256 hashed: cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416)
INSERT IGNORE INTO users (email, password, fullname, phone, role) VALUES
('teacher1@ptit.edu.vn', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Nguyễn Văn A - Giáo viên Python', '0912345671', 'teacher'),
('teacher2@ptit.edu.vn', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Trần Thị B - Giáo viên Tài chính', '0912345672', 'teacher'),
('teacher3@ptit.edu.vn', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Lê Văn C - Giáo viên Data', '0912345673', 'teacher'),
('teacher4@ptit.edu.vn', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Phạm Thị D - Giáo viên Blockchain', '0912345674', 'teacher'),
('teacher5@ptit.edu.vn', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Hoàng Văn E - Giáo viên Kế toán', '0912345675', 'teacher'),
('teacher6@ptit.edu.vn', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Đỗ Thị F - Giáo viên Marketing', '0912345676', 'teacher');

-- ============================================
-- Insert Test Student Account
-- ============================================
-- Password: 123456 (SHA-256 hashed)
INSERT IGNORE INTO users (email, password, fullname, phone, role) VALUES
('test@ptit.edu.vn', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Sinh viên Test', '0987654321', 'student');

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
-- Insert Sample Users
-- Password: 123456 (SHA-256 hashed)
-- ============================================

-- Test User
INSERT INTO users (email, phone, password_hash, fullname) VALUES
('test@ptit.edu.vn', '0123456789', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Nguyen Van Test')
ON DUPLICATE KEY UPDATE email=email;

-- ============================================
-- Insert 6 Teacher Accounts
-- Password for all: teacher123 (SHA-256 hashed)
-- Each teacher manages one category with 6 courses
-- ============================================
INSERT INTO users (email, phone, password_hash, fullname) VALUES
('teacher1@ptit.edu.vn', '0901000001', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Nguyen Van Python'),
('teacher2@ptit.edu.vn', '0901000002', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Tran Thi Finance'),
('teacher3@ptit.edu.vn', '0901000003', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Le Van Data'),
('teacher4@ptit.edu.vn', '0901000004', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Pham Thi Blockchain'),
('teacher5@ptit.edu.vn', '0901000005', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Hoang Van Accounting'),
('teacher6@ptit.edu.vn', '0901000006', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Vu Thi Marketing')
ON DUPLICATE KEY UPDATE email=email;

-- ============================================
-- Assign Courses to Teachers
-- Teacher 1: Python courses (6 courses)
-- Teacher 2: Finance courses (6 courses)
-- Teacher 3: Data courses (6 courses)
-- Teacher 4: Blockchain courses (6 courses)
-- Teacher 5: Accounting courses (6 courses)
-- Teacher 6: Marketing courses (6 courses)
-- ============================================

-- Teacher 1 - Python courses
INSERT IGNORE INTO teacher_courses (teacher_id, course_id)
SELECT u.user_id, c.course_id
FROM users u
CROSS JOIN courses c
WHERE u.email = 'teacher1@ptit.edu.vn' 
AND c.course_id IN ('python-procedural', 'python-basics', 'python-complete', 'python-excel', 'selenium-python', 'python-oop');

-- Teacher 2 - Finance courses
INSERT IGNORE INTO teacher_courses (teacher_id, course_id)
SELECT u.user_id, c.course_id
FROM users u
CROSS JOIN courses c
WHERE u.email = 'teacher2@ptit.edu.vn' 
AND c.course_id IN ('finance-basic', 'investment', 'banking', 'personal-finance', 'forex', 'financial-analysis');

-- Teacher 3 - Data courses
INSERT IGNORE INTO teacher_courses (teacher_id, course_id)
SELECT u.user_id, c.course_id
FROM users u
CROSS JOIN courses c
WHERE u.email = 'teacher3@ptit.edu.vn' 
AND c.course_id IN ('data-basic', 'excel-data', 'sql-data', 'power-bi', 'python-data', 'tableau');

-- Teacher 4 - Blockchain courses
INSERT IGNORE INTO teacher_courses (teacher_id, course_id)
SELECT u.user_id, c.course_id
FROM users u
CROSS JOIN courses c
WHERE u.email = 'teacher4@ptit.edu.vn' 
AND c.course_id IN ('blockchain-basic', 'smart-contract', 'defi', 'nft', 'web3', 'crypto-trading');

-- Teacher 5 - Accounting courses
INSERT IGNORE INTO teacher_courses (teacher_id, course_id)
SELECT u.user_id, c.course_id
FROM users u
CROSS JOIN courses c
WHERE u.email = 'teacher5@ptit.edu.vn' 
AND c.course_id IN ('accounting-basic', 'accounting-misa', 'tax-accounting', 'cost-accounting', 'excel-accounting', 'financial-statements');

-- Teacher 6 - Marketing courses
INSERT IGNORE INTO teacher_courses (teacher_id, course_id)
SELECT u.user_id, c.course_id
FROM users u
CROSS JOIN courses c
WHERE u.email = 'teacher6@ptit.edu.vn' 
AND c.course_id IN ('digital-marketing', 'facebook-ads', 'google-ads', 'content-marketing', 'social-media', 'email-marketing');

-- ============================================
-- OPTIONAL: Sample Orders and Progress Data
-- Uncomment below sections if you want sample order data
-- ============================================

-- Sample Orders (for testing with user_id = 1)
-- INSERT IGNORE INTO orders (user_id, total_amount, payment_method, status, created_at) VALUES
-- (1, 2298000, 'cod', 'completed', '2025-10-15 10:30:00'),
-- (1, 1299000, 'bank', 'completed', '2025-11-01 14:20:00');

-- Get the order IDs and insert order items manually:
-- SET @order1 = (SELECT order_id FROM orders WHERE user_id = 1 ORDER BY created_at LIMIT 1);
-- SET @order2 = (SELECT order_id FROM orders WHERE user_id = 1 ORDER BY created_at DESC LIMIT 1);

-- INSERT IGNORE INTO order_items (order_id, course_id, price) VALUES
-- (@order1, 'python-basics', 999000),
-- (@order1, 'finance-basic', 1299000),
-- (@order2, 'python-complete', 2499000);

-- Sample Course Progress (for testing)
-- INSERT IGNORE INTO course_progress (user_id, course_id, progress_percentage, total_hours, status) VALUES
-- (1, 'python-basics', 75, 30.5, 'in_progress'),
-- (1, 'finance-basic', 100, 45.0, 'completed'),
-- (1, 'python-complete', 25, 15.0, 'in_progress');

-- ============================================
-- NOTES:
-- ============================================
-- 1. Default user accounts:
--    Test User:
--      Email: test@ptit.edu.vn
--      Password: 123456
--
--    Teacher Accounts (Password for all: teacher123):
--      Teacher 1 - Python:     teacher1@ptit.edu.vn / 0901000001 / Nguyen Van Python
--      Teacher 2 - Finance:    teacher2@ptit.edu.vn / 0901000002 / Tran Thi Finance
--      Teacher 3 - Data:       teacher3@ptit.edu.vn / 0901000003 / Le Van Data
--      Teacher 4 - Blockchain: teacher4@ptit.edu.vn / 0901000004 / Pham Thi Blockchain
--      Teacher 5 - Accounting: teacher5@ptit.edu.vn / 0901000005 / Hoang Van Accounting
--      Teacher 6 - Marketing:  teacher6@ptit.edu.vn / 0901000006 / Vu Thi Marketing
--
-- 2. Sample data includes:
--    - 36 courses across 6 categories:
--      * Python (6 courses) - Managed by Teacher 1
--      * Finance (6 courses) - Managed by Teacher 2
--      * Data Analysis (6 courses) - Managed by Teacher 3
--      * Blockchain (6 courses) - Managed by Teacher 4
--      * Accounting (6 courses) - Managed by Teacher 5
--      * Marketing (6 courses) - Managed by Teacher 6
--    - 1 test user for login testing
--    - 6 teacher accounts with course assignments
--    - Course thumbnails are set to existing image paths
--
-- 3. Teacher-Course assignments:
--    - Each teacher manages exactly 6 courses in their subject
--    - Assignments are in teacher_courses table
--    - Teachers can view student progress for their assigned courses
--
-- 4. For production deployment:
--    - Create admin account: admin@ptit.edu.vn
--    - Update teacher passwords to secure ones
--    - Add real course content and lessons
--    - Configure proper thumbnail paths
--
-- 5. Optional sample data (commented out):
--    - Sample orders for user_id = 1
--    - Sample course progress tracking
--    - Uncomment if needed for testing
