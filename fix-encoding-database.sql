-- ============================================
-- FIX ENCODING VÀ RESET DATABASE HOÀN TOÀN
-- CHẠY SCRIPT NÀY TRONG MySQL Workbench hoặc phpMyAdmin
-- ============================================

USE ptit_learning;

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
SET foreign_key_checks = 0;

-- ============================================
-- BƯỚC 1: XÓA TOÀN BỘ DỮ LIỆU USER VÀ TIẾN TRÌNH
-- ============================================
TRUNCATE TABLE course_progress;
TRUNCATE TABLE order_items;
TRUNCATE TABLE orders;
TRUNCATE TABLE cart;

-- ============================================
-- BƯỚC 2: DROP VÀ TẠO LẠI TABLE COURSES VỚI UTF-8 CHUẨN
-- ============================================
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

-- ============================================
-- BƯỚC 3: INSERT COURSES VỚI TIẾNG VIỆT CHUẨN
-- ============================================

-- Python Courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('python-procedural', 'Procedural Python - Lập trình hàm trong Python', 'python', 'Học lập trình hàm trong Python từ cơ bản đến nâng cao, áp dụng vào dự án thực tế', 1299000, 2499000, '12 giờ', 1234, 'Beginner', 1, 48),
('python-basics', 'Python Basics - Lập trình Python cơ bản', 'python', 'Khóa học Python cho người mới bắt đầu, từ zero đến hero', 999000, 1999000, '10 giờ', 2567, 'Beginner', 0, 50),
('python-complete', 'Python Toàn Tập - Từ Zero đến Hero', 'python', 'Khóa học Python toàn diện nhất, bao gồm tất cả kiến thức cần thiết', 2499000, 4999000, '40 giờ', 5678, 'All', 0, 50),
('python-excel', 'Python Excel cho người đi làm', 'python', 'Tự động hóa Excel bằng Python, tiết kiệm thời gian làm việc', 899000, 1799000, '8 giờ', 1890, 'Intermediate', 0, 50),
('selenium-python', 'Selenium Python - Test Automation', 'python', 'Automation testing với Selenium và Python', 1599000, 2999000, '18 giờ', 987, 'Advanced', 0, 47),
('python-oop', 'Python OOP - Lập trình hướng đối tượng', 'python', 'Lập trình hướng đối tượng với Python, từ cơ bản đến nâng cao', 1199000, 2399000, '14 giờ', 756, 'Intermediate', 0, 50);

-- Finance Courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('finance-basic', 'Tài chính cơ bản', 'finance', 'Kiến thức nền tảng tài chính cho người mới bắt đầu', 799000, 1599000, '10 giờ', 2345, 'Beginner', 1, 50),
('investment', 'Đầu tư chứng khoán từ A-Z', 'finance', 'Phân tích và chiến lược đầu tư chứng khoán', 1699000, 3099000, '20 giờ', 3890, 'Intermediate', 1, 45),
('banking', 'Nghiệp vụ ngân hàng hiện đại', 'finance', 'Khóa học Nghiệp vụ Ngân hàng Thương mại từ TS Lê Thẩm Dương', 1299000, 2599000, '8.5 giờ', 1982, 'Intermediate', 0, 50),
('personal-finance', 'Quản lý tài chính cá nhân thông minh', 'finance', 'Hành trình Tự do Tài chính từ A-Z', 699000, 1399000, '4.2 giờ', 2812, 'Beginner', 1, 50),
('forex', 'Trading Forex cho người mới', 'finance', 'Khóa học Trading Forex toàn diện từ cơ bản đến chuyên nghiệp', 1599000, 2999000, '12 giờ', 2678, 'Advanced', 0, 47),
('financial-analysis', 'Phân tích báo cáo tài chính doanh nghiệp', 'finance', 'Khóa học Phân tích báo cáo tài chính toàn diện', 1499000, 2999000, '7 giờ', 1876, 'Intermediate', 0, 50);

-- Data Analyst Courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('data-basic', 'Data Analytics cơ bản', 'data', 'Khóa học phân tích dữ liệu cho người mới bắt đầu', 899000, 1799000, '12 giờ', 1567, 'Beginner', 1, 50),
('excel-data', 'Excel cho Data Analyst', 'data', 'Excel nâng cao cho phân tích dữ liệu', 799000, 1599000, '10 giờ', 2134, 'Beginner', 0, 50),
('sql-data', 'SQL cho Data Analyst', 'data', 'Học SQL từ cơ bản đến nâng cao cho Data Analyst', 1299000, 2599000, '16 giờ', 1876, 'Intermediate', 0, 50),
('power-bi', 'Power BI toàn tập', 'data', 'Trực quan hóa dữ liệu với Power BI', 1499000, 2999000, '18 giờ', 1654, 'Intermediate', 0, 50),
('python-data', 'Python cho Data Science', 'data', 'Python cho phân tích và khoa học dữ liệu', 1599000, 3199000, '20 giờ', 2234, 'Advanced', 0, 50),
('tableau', 'Tableau Desktop chuyên nghiệp', 'data', 'Trực quan hóa dữ liệu với Tableau', 1399000, 2799000, '16 giờ', 1423, 'Intermediate', 0, 50);

-- Blockchain Courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('blockchain-basic', 'Blockchain cơ bản', 'blockchain', 'Kiến thức nền tảng về công nghệ Blockchain', 1299000, 2599000, '14 giờ', 1234, 'Beginner', 1, 50),
('smart-contract', 'Smart Contract với Solidity', 'blockchain', 'Lập trình Smart Contract trên Ethereum', 2099000, 4199000, '24 giờ', 876, 'Advanced', 0, 50),
('defi', 'DeFi toàn tập', 'blockchain', 'Tài chính phi tập trung - DeFi từ A đến Z', 1799000, 3599000, '20 giờ', 1543, 'Intermediate', 0, 50),
('nft', 'NFT và Metaverse', 'blockchain', 'NFT, Metaverse và tương lai của Web3', 1499000, 2999000, '16 giờ', 1876, 'Intermediate', 0, 50),
('web3', 'Web3 Development', 'blockchain', 'Phát triển ứng dụng Web3 toàn diện', 2299000, 4599000, '28 giờ', 765, 'Advanced', 0, 50),
('crypto-trading', 'Crypto Trading chuyên nghiệp', 'blockchain', 'Giao dịch tiền điện tử chuyên nghiệp', 1899000, 3799000, '22 giờ', 1234, 'Intermediate', 0, 50);

-- Accounting Courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('accounting-basic', 'Kế toán cơ bản', 'accounting', 'Nguyên lý kế toán cho người mới bắt đầu', 699000, 1399000, '10 giờ', 2345, 'Beginner', 1, 50),
('accounting-misa', 'Kế toán trên phần mềm MISA', 'accounting', 'Thực hành kế toán với phần mềm MISA', 1299000, 2599000, '16 giờ', 1876, 'Intermediate', 0, 50),
('tax-accounting', 'Kế toán thuế', 'accounting', 'Kế toán thuế doanh nghiệp và cá nhân', 1499000, 2999000, '18 giờ', 1543, 'Intermediate', 0, 50),
('cost-accounting', 'Kế toán chi phí', 'accounting', 'Kế toán và quản trị chi phí doanh nghiệp', 899000, 1799000, '12 giờ', 1234, 'Intermediate', 0, 50),
('excel-accounting', 'Excel cho kế toán', 'accounting', 'Excel nâng cao cho nghề kế toán', 799000, 1599000, '10 giờ', 2134, 'Beginner', 0, 50),
('financial-statements', 'Lập và phân tích báo cáo tài chính', 'accounting', 'Lập và phân tích báo cáo tài chính doanh nghiệp', 1399000, 2799000, '16 giờ', 1654, 'Advanced', 0, 50);

-- Marketing Courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, is_new, discount_percentage) VALUES
('digital-marketing', 'Digital Marketing toàn diện', 'marketing', 'Marketing kỹ thuật số từ A đến Z', 1499000, 2999000, '20 giờ', 3456, 'Beginner', 1, 50),
('facebook-ads', 'Facebook Ads chuyên nghiệp', 'marketing', 'Quảng cáo Facebook hiệu quả và tối ưu chi phí', 1299000, 2599000, '16 giờ', 2345, 'Intermediate', 0, 50),
('google-ads', 'Google Ads & SEO', 'marketing', 'Quảng cáo Google và tối ưu hóa công cụ tìm kiếm', 1599000, 3199000, '18 giờ', 2134, 'Intermediate', 0, 50),
('content-marketing', 'Content Marketing hiệu quả', 'marketing', 'Xây dựng chiến lược content marketing bài bản', 1199000, 2399000, '14 giờ', 1876, 'Intermediate', 0, 50),
('social-media', 'Social Media Marketing', 'marketing', 'Marketing trên các nền tảng mạng xã hội', 899000, 1799000, '12 giờ', 2567, 'Beginner', 0, 50),
('email-marketing', 'Email Marketing chuyên nghiệp', 'marketing', 'Chiến lược email marketing hiệu quả', 999000, 1999000, '10 giờ', 1654, 'Beginner', 0, 50);

-- ============================================
-- BƯỚC 4: CẬP NHẬT THUMBNAILS
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

SET foreign_key_checks = 1;

-- ============================================
-- KIỂM TRA KẾT QUẢ
-- ============================================
SELECT 'KIỂM TRA ENCODING' as thong_bao;
SELECT course_id, course_name, category FROM courses LIMIT 5;

SELECT 'TỔNG SỐ KHÓA HỌC' as thong_bao, COUNT(*) as so_luong FROM courses;

-- ============================================
-- HOÀN THÀNH!
-- Tất cả data đã được reset và encoding đã đúng UTF-8
-- ============================================