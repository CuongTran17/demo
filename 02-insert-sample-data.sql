-- ============================================
-- PTIT LEARNING - DỮ LIỆU MẪU
-- Insert dữ liệu mẫu cho testing
-- Encoding: UTF-8
-- Password Hash: SHA-256
-- ============================================

USE ptit_learning;

-- ============================================
-- BƯỚC 1: Insert tài khoản người dùng
-- ============================================

-- Test User: test@ptit.edu.vn / Password: 123456
-- Hash: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
INSERT INTO users (email, phone, password_hash, fullname) VALUES
('test@ptit.edu.vn', '0123456789', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Nguyễn Văn Test')
ON DUPLICATE KEY UPDATE email=email;

-- Admin Account: admin@ptit.edu.vn / Password: admin123
-- Hash: 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9
INSERT INTO users (email, phone, password_hash, fullname) VALUES
('admin@ptit.edu.vn', '0999999999', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Quản trị viên')
ON DUPLICATE KEY UPDATE email=email;

-- Teacher Accounts: Password for all: teacher123
-- Hash: cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416
INSERT INTO users (email, phone, password_hash, fullname) VALUES
('teacher1@ptit.edu.vn', '0901000001', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Nguyễn Văn Python'),
('teacher2@ptit.edu.vn', '0901000002', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Trần Thị Tài Chính'),
('teacher3@ptit.edu.vn', '0901000003', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Lê Văn Dữ Liệu'),
('teacher4@ptit.edu.vn', '0901000004', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Phạm Thị Blockchain'),
('teacher5@ptit.edu.vn', '0901000005', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Hoàng Văn Kế Toán'),
('teacher6@ptit.edu.vn', '0901000006', 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416', 'Vũ Thị Marketing')
ON DUPLICATE KEY UPDATE email=email;

-- ============================================
-- BƯỚC 2: Insert khóa học - Python (6 courses)
-- ============================================
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('python-procedural', 'Procedural Python - Lập trình hàm trong Python', 'python', 'Học lập trình hàm trong Python từ cơ bản đến nâng cao, áp dụng vào dự án thực tế', 1299000, 2499000, '12 giờ', 1234, 'Beginner', 'assets/img/Index/python.png', 1, 48),
('python-basics', 'Python Basics - Lập trình Python cơ bản', 'python', 'Khóa học Python cho người mới bắt đầu, từ zero đến hero', 999000, 1999000, '10 giờ', 2567, 'Beginner', 'assets/img/Index/python.png', 0, 50),
('python-complete', 'Python Toàn Tập - Từ Zero đến Hero', 'python', 'Khóa học Python toàn diện nhất, bao gồm tất cả kiến thức cần thiết', 2499000, 4999000, '40 giờ', 5678, 'All', 'assets/img/Index/python.png', 0, 50),
('python-excel', 'Python Excel cho người đi làm', 'python', 'Tự động hóa Excel bằng Python, tiết kiệm thời gian làm việc', 899000, 1799000, '8 giờ', 1890, 'Intermediate', 'assets/img/Index/python.png', 0, 50),
('selenium-python', 'Selenium Python - Test Automation', 'python', 'Automation testing với Selenium và Python', 1599000, 2999000, '18 giờ', 987, 'Advanced', 'assets/img/Index/python.png', 0, 47),
('python-oop', 'Python OOP - Lập trình hướng đối tượng', 'python', 'Lập trình hướng đối tượng với Python, từ cơ bản đến nâng cao', 1199000, 2399000, '14 giờ', 756, 'Intermediate', 'assets/img/Index/python.png', 0, 50)
AS new_courses
ON DUPLICATE KEY UPDATE 
    course_name = new_courses.course_name,
    description = new_courses.description,
    price = new_courses.price;

-- ============================================
-- Insert khóa học - Tài chính (6 courses)
-- ============================================
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('finance-basic', 'Tài chính cơ bản', 'finance', 'Kiến thức nền tảng tài chính cho người mới bắt đầu', 799000, 1599000, '10 giờ', 2345, 'Beginner', 'assets/img/courses-finance/Tài chính cơ bản.png', 1, 50),
('investment', 'Đầu tư chứng khoán từ A-Z', 'finance', 'Phân tích và chiến lược đầu tư chứng khoán', 1699000, 3099000, '20 giờ', 3890, 'Intermediate', 'assets/img/courses-finance/Đầu tư chứng khoán.png', 1, 45),
('banking', 'Nghiệp vụ ngân hàng hiện đại', 'finance', 'Khóa học Nghiệp vụ Ngân hàng Thương mại từ TS Lê Thẩm Dương - Từ lý thuyết cơ bản đến nghiệp vụ tín dụng chuyên sâu', 1299000, 2599000, '8.5 giờ', 1982, 'Intermediate', 'assets/img/courses-finance/Ngân hàng.png', 0, 50),
('personal-finance', 'Tài chính cá nhân thông minh', 'finance', 'Hành trình Tự do Tài chính từ A-Z - Series đầy đủ từ Hieu Nguyen về quản lý tài chính, đầu tư và xây dựng thu nhập thụ động', 699000, 1399000, '4.2 giờ', 2812, 'Beginner', 'assets/img/courses-finance/Tài chính cá nhân.png', 1, 50),
('forex', 'Trading Forex cho người mới', 'finance', 'Khóa học Trading Forex toàn diện từ fxalexg - 22 video hướng dẫn từ cơ bản đến chuyên nghiệp, bao gồm chiến lược swing trading, day trading, quản lý rủi ro và tăng trưởng tài khoản', 1599000, 2999000, '12 giờ', 2678, 'Advanced', 'assets/img/courses-finance/Forex.png', 0, 47),
('financial-analysis', 'Phân tích báo cáo tài chính', 'finance', 'Khóa học Phân tích báo cáo tài chính toàn diện từ Ths. Võ Minh Long - 7 video chuyên sâu về cách đọc, phân tích bảng cân đối kế toán, báo cáo lưu chuyển tiền tệ, tỷ số tài chính và case study thực tế', 1499000, 2999000, '7 giờ', 1876, 'Intermediate', 'assets/img/courses-finance/Phân tích tài chính.png', 0, 50)
AS new_courses
ON DUPLICATE KEY UPDATE 
    course_name = new_courses.course_name,
    description = new_courses.description,
    price = new_courses.price;

-- ============================================
-- Insert khóa học - Phân tích dữ liệu (6 courses)
-- ============================================
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('data-basic', 'Data Analytics cơ bản', 'data', 'Khóa học phân tích dữ liệu cho người mới bắt đầu', 899000, 1799000, '12 giờ', 1567, 'Beginner', 'assets/img/Index/python.png', 1, 50),
('excel-data', 'Excel cho Data Analyst', 'data', 'Excel nâng cao cho phân tích dữ liệu', 799000, 1599000, '10 giờ', 2134, 'Beginner', 'assets/img/Index/python.png', 0, 50),
('sql-data', 'SQL cho Data Analyst', 'data', 'Học SQL từ cơ bản đến nâng cao cho Data Analyst', 1299000, 2599000, '16 giờ', 1876, 'Intermediate', 'assets/img/Index/python.png', 0, 50),
('power-bi', 'Power BI toàn tập', 'data', 'Trực quan hóa dữ liệu với Power BI', 1499000, 2999000, '18 giờ', 1654, 'Intermediate', 'assets/img/Index/python.png', 0, 50),
('python-data', 'Python cho Data Science', 'data', 'Python cho phân tích và khoa học dữ liệu', 1599000, 3199000, '20 giờ', 2234, 'Advanced', 'assets/img/Index/python.png', 0, 50),
('tableau', 'Tableau Desktop chuyên nghiệp', 'data', 'Trực quan hóa dữ liệu với Tableau', 1399000, 2799000, '16 giờ', 1423, 'Intermediate', 'assets/img/Index/python.png', 0, 50)
AS new_courses
ON DUPLICATE KEY UPDATE 
    course_name = new_courses.course_name,
    description = new_courses.description,
    price = new_courses.price;

-- ============================================
-- Insert khóa học - Blockchain (6 courses)
-- ============================================
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('blockchain-basic', 'Blockchain cơ bản', 'blockchain', 'Kiến thức nền tảng về công nghệ Blockchain', 1299000, 2599000, '14 giờ', 1234, 'Beginner', 'assets/img/Index/blockchian.png', 1, 50),
('smart-contract', 'Smart Contract với Solidity', 'blockchain', 'Lập trình Smart Contract trên Ethereum', 2099000, 4199000, '24 giờ', 876, 'Advanced', 'assets/img/Index/blockchian.png', 0, 50),
('defi', 'DeFi toàn tập', 'blockchain', 'Tài chính phi tập trung - DeFi từ A đến Z', 1799000, 3599000, '20 giờ', 1543, 'Intermediate', 'assets/img/Index/blockchian.png', 0, 50),
('nft', 'NFT và Metaverse', 'blockchain', 'NFT, Metaverse và tương lai của Web3', 1499000, 2999000, '16 giờ', 1876, 'Intermediate', 'assets/img/Index/blockchian.png', 0, 50),
('web3', 'Web3 Development', 'blockchain', 'Phát triển ứng dụng Web3 toàn diện', 2299000, 4599000, '28 giờ', 765, 'Advanced', 'assets/img/Index/blockchian.png', 0, 50),
('crypto-trading', 'Crypto Trading chuyên nghiệp', 'blockchain', 'Giao dịch tiền điện tử chuyên nghiệp', 1899000, 3799000, '22 giờ', 1234, 'Intermediate', 'assets/img/Index/blockchian.png', 0, 50)
AS new_courses
ON DUPLICATE KEY UPDATE 
    course_name = new_courses.course_name,
    description = new_courses.description,
    price = new_courses.price;

-- ============================================
-- Insert khóa học - Kế toán (6 courses)
-- ============================================
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('accounting-basic', 'Kế toán cơ bản', 'accounting', 'Nguyên lý kế toán cho người mới bắt đầu', 699000, 1399000, '10 giờ', 2345, 'Beginner', 'assets/img/Index/kế toàn cơ bản.png', 1, 50),
('accounting-misa', 'Kế toán trên phần mềm MISA', 'accounting', 'Thực hành kế toán với phần mềm MISA', 1299000, 2599000, '16 giờ', 1876, 'Intermediate', 'assets/img/Index/kế toàn cơ bản.png', 0, 50),
('tax-accounting', 'Kế toán thuế', 'accounting', 'Kế toán thuế doanh nghiệp và cá nhân', 1499000, 2999000, '18 giờ', 1543, 'Intermediate', 'assets/img/Index/kế toàn cơ bản.png', 0, 50),
('cost-accounting', 'Kế toán chi phí', 'accounting', 'Kế toán và quản trị chi phí doanh nghiệp', 899000, 1799000, '12 giờ', 1234, 'Intermediate', 'assets/img/Index/kế toàn cơ bản.png', 0, 50),
('excel-accounting', 'Excel cho kế toán', 'accounting', 'Excel nâng cao cho nghề kế toán', 799000, 1599000, '10 giờ', 2134, 'Beginner', 'assets/img/Index/kế toàn cơ bản.png', 0, 50),
('financial-statements', 'Lập và phân tích báo cáo tài chính', 'accounting', 'Lập và phân tích báo cáo tài chính doanh nghiệp', 1399000, 2799000, '16 giờ', 1654, 'Advanced', 'assets/img/Index/kế toàn cơ bản.png', 0, 50)
AS new_courses
ON DUPLICATE KEY UPDATE 
    course_name = new_courses.course_name,
    description = new_courses.description,
    price = new_courses.price;

-- ============================================
-- Insert khóa học - Marketing (6 courses)
-- ============================================
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('digital-marketing', 'Digital Marketing toàn diện', 'marketing', 'Marketing kỹ thuật số từ A đến Z', 1499000, 2999000, '20 giờ', 3456, 'Beginner', 'assets/img/Index/combo sv kinh tế.png', 1, 50),
('facebook-ads', 'Facebook Ads chuyên nghiệp', 'marketing', 'Quảng cáo Facebook hiệu quả và tối ưu chi phí', 1299000, 2599000, '16 giờ', 2345, 'Intermediate', 'assets/img/Index/combo sv kinh tế.png', 0, 50),
('google-ads', 'Google Ads & SEO', 'marketing', 'Quảng cáo Google và tối ưu hóa công cụ tìm kiếm', 1599000, 3199000, '18 giờ', 2134, 'Intermediate', 'assets/img/Index/combo sv kinh tế.png', 0, 50),
('content-marketing', 'Content Marketing hiệu quả', 'marketing', 'Xây dựng chiến lược content marketing bài bản', 1199000, 2399000, '14 giờ', 1876, 'Intermediate', 'assets/img/Index/combo sv kinh tế.png', 0, 50),
('social-media', 'Social Media Marketing', 'marketing', 'Marketing trên các nền tảng mạng xã hội', 899000, 1799000, '12 giờ', 2567, 'Beginner', 'assets/img/Index/combo sv kinh tế.png', 0, 50),
('email-marketing', 'Email Marketing chuyên nghiệp', 'marketing', 'Chiến lược email marketing hiệu quả', 999000, 1999000, '10 giờ', 1654, 'Beginner', 'assets/img/Index/combo sv kinh tế.png', 0, 50)
AS new_courses
ON DUPLICATE KEY UPDATE 
    course_name = new_courses.course_name,
    description = new_courses.description,
    price = new_courses.price;

-- ============================================
-- BƯỚC 3: Phân công giảng viên cho khóa học
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
-- Hoàn tất insert dữ liệu
-- ============================================
SELECT '✓ Dữ liệu mẫu đã được import thành công!' AS status;
SELECT CONCAT('Tổng số users: ', COUNT(*)) AS info FROM users;
SELECT CONCAT('Tổng số courses: ', COUNT(*)) AS info FROM courses;
SELECT CONCAT('Tổng số teacher assignments: ', COUNT(*)) AS info FROM teacher_courses;

-- ============================================
-- THÔNG TIN ĐĂNG NHẬP MẶC ĐỊNH
-- ============================================
-- Test User:
--   Email: test@ptit.edu.vn
--   Password: 123456
--
-- Admin Account:
--   Email: admin@ptit.edu.vn
--   Password: admin123
--
-- Teacher Accounts (Password for all: teacher123):
--   Teacher 1 - Python:     teacher1@ptit.edu.vn
--   Teacher 2 - Finance:    teacher2@ptit.edu.vn
--   Teacher 3 - Data:       teacher3@ptit.edu.vn
--   Teacher 4 - Blockchain: teacher4@ptit.edu.vn
--   Teacher 5 - Accounting: teacher5@ptit.edu.vn
--   Teacher 6 - Marketing:  teacher6@ptit.edu.vn
--
-- Tổng số khóa học: 36 courses (6 categories x 6 courses)
-- ============================================
