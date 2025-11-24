-- Reimport clean Vietnamese data
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;
USE ptit_learning;

SET FOREIGN_KEY_CHECKS = 0;

-- Truncate and reinsert users
TRUNCATE TABLE teacher_courses;
TRUNCATE TABLE course_progress;
TRUNCATE TABLE lesson_progress;
TRUNCATE TABLE order_items;
TRUNCATE TABLE cart;
TRUNCATE TABLE orders;
TRUNCATE TABLE lessons;
TRUNCATE TABLE courses;
TRUNCATE TABLE users;

-- Insert users with proper Vietnamese encoding
INSERT INTO users (email, phone, password_hash, fullname) VALUES
('admin@ptit.edu.vn', '0123456789', '$2a$10$dummyhash1', 'Administrator'),
('teacher1@ptit.edu.vn', '0123456781', '$2a$10$dummyhash2', 'Nguyễn Văn Python'),
('teacher2@ptit.edu.vn', '0123456782', '$2a$10$dummyhash3', 'Trần Thị Finance'),
('teacher3@ptit.edu.vn', '0123456783', '$2a$10$dummyhash4', 'Lê Văn Data'),
('teacher4@ptit.edu.vn', '0123456784', '$2a$10$dummyhash5', 'Phạm Thị Blockchain'),
('teacher5@ptit.edu.vn', '0123456785', '$2a$10$dummyhash6', 'Hoàng Văn Accounting'),
('teacher6@ptit.edu.vn', '0123456786', '$2a$10$dummyhash7', 'Vũ Thị Marketing'),
('tranduccuong17@gmail.com', '0987654321', '$2a$10$N9qo8uLOickgx2ZMRZoMye', 'Trần Đức Cường'),
('student1@gmail.com', '0987654322', '$2a$10$dummyhash8', 'Trần Thị Mai');

-- Python courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('python-procedural', 'Procedural Python - Lập trình hàm trong Python', 'python', 'Học lập trình hàm trong Python từ cơ bản đến nâng cao, áp dụng vào dự án thực tế', 1299000, 2499000, '12 giờ', 1234, 'Beginner', 'assets/img/courses-python/python-procedural.png', 1, 48),
('python-basics', 'Python Basics - Lập trình Python cơ bản', 'python', 'Khóa học Python cho người mới bắt đầu, từ zero đến hero', 999000, 1999000, '10 giờ', 2567, 'Beginner', 'assets/img/courses-python/python-basics.png', 0, 50),
('python-complete', 'Python Toàn Tập - Từ Zero Đến Hero', 'python', 'Khóa học Python toàn diện nhất, bao gồm tất cả kiến thức cần thiết', 2499000, 4999000, '40 giờ', 5678, 'All', 'assets/img/courses-python/python-complete.png', 0, 50),
('python-excel', 'Python Excel cho người đi làm', 'python', 'Tự động hóa Excel bằng Python, tiết kiệm thời gian làm việc', 899000, 1799000, '8 giờ', 1890, 'Intermediate', 'assets/img/courses-python/python-excel.png', 0, 50),
('selenium-python', 'Selenium Python - Test Automation', 'python', 'Automation testing với Selenium và Python', 1599000, 2999000, '18 giờ', 987, 'Advanced', 'assets/img/courses-python/selenium-python.png', 0, 47),
('python-oop', 'Python OOP - Lập trình hướng đối tượng', 'python', 'Lập trình hướng đối tượng với Python, từ cơ bản đến nâng cao', 1199000, 2399000, '14 giờ', 756, 'Intermediate', 'assets/img/courses-python/python-oop.png', 0, 50);

-- Finance courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('finance-basic', 'Tài chính cơ bản', 'finance', 'Học các khái niệm tài chính nền tảng, quản lý chi tiêu cá nhân hiệu quả', 799000, 1599000, '10 giờ', 2145, 'Beginner', 'assets/img/courses-finance/finance-basic.png', 1, 50),
('investment', 'Đầu tư chứng khoán từ A-Z', 'finance', 'Phân tích và chiến lược đầu tư chứng khoán', 1699000, 3099000, '20 giờ', 3890, 'Intermediate', 'assets/img/courses-finance/investment.png', 1, 45),
('banking', 'Nghiệp vụ ngân hàng hiện đại', 'finance', 'Khóa học Nghiệp vụ Ngân hàng Thương mại từ TS Lê Thẩm Dương', 1299000, 2599000, '8.5 giờ', 1982, 'Intermediate', 'assets/img/courses-finance/banking.png', 0, 50),
('personal-finance', 'Tài chính cá nhân thông minh', 'finance', 'Hành trình Tự do Tài chính từ A-Z', 699000, 1399000, '4.2 giờ', 2812, 'Beginner', 'assets/img/courses-finance/personal-finance.png', 1, 50),
('forex', 'Trading Forex cho người mới', 'finance', 'Khóa học Trading Forex toàn diện từ fxalexg', 1599000, 2999000, '12 giờ', 2678, 'Advanced', 'assets/img/courses-finance/Forex.png', 0, 47),
('financial-analysis', 'Phân tích báo cáo tài chính', 'finance', 'Khóa học Phân tích báo cáo tài chính toàn diện', 1499000, 2999000, '7 giờ', 1876, 'Intermediate', 'assets/img/courses-finance/financial-analysis.png', 0, 50);

-- Data courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('data-basic', 'Data Analytics cơ bản', 'data', 'Khóa học phân tích dữ liệu cho người mới bắt đầu', 899000, 1799000, '12 giờ', 1567, 'Beginner', 'assets/img/courses-data/data-basic.png', 1, 50),
('excel-data', 'Excel cho Data Analyst', 'data', 'Excel nâng cao cho phân tích dữ liệu', 799000, 1599000, '10 giờ', 2134, 'Beginner', 'assets/img/courses-data/excel-data.png', 0, 50),
('sql-data', 'SQL cho Data Analyst', 'data', 'Học SQL từ cơ bản đến nâng cao cho Data Analyst', 1299000, 2599000, '16 giờ', 1876, 'Intermediate', 'assets/img/courses-data/sql-data.png', 0, 50),
('power-bi', 'Power BI toàn tập', 'data', 'Trực quan hóa dữ liệu với Power BI', 1499000, 2999000, '18 giờ', 1654, 'Intermediate', 'assets/img/courses-data/power-bi.png', 0, 50),
('python-data', 'Python cho Data Science', 'data', 'Python cho phân tích và khoa học dữ liệu', 1599000, 3199000, '20 giờ', 2234, 'Advanced', 'assets/img/courses-data/python-data.png', 0, 50),
('tableau', 'Tableau Desktop chuyên nghiệp', 'data', 'Trực quan hóa dữ liệu với Tableau', 1399000, 2799000, '16 giờ', 1423, 'Intermediate', 'assets/img/courses-data/Tableau.png', 0, 50);

-- Blockchain courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('blockchain-basic', 'Blockchain cơ bản', 'blockchain', 'Kiến thức nền tảng về công nghệ Blockchain', 1299000, 2599000, '14 giờ', 1234, 'Beginner', 'assets/img/courses-blockchain/blockchain-basic.png', 1, 50),
('smart-contract', 'Smart Contract với Solidity', 'blockchain', 'Lập trình Smart Contract trên Ethereum', 2099000, 4199000, '24 giờ', 876, 'Advanced', 'assets/img/courses-blockchain/smart-contract.png', 0, 50),
('defi', 'DeFi toàn tập', 'blockchain', 'Tài chính phi tập trung - DeFi từ A đến Z', 1799000, 3599000, '20 giờ', 1543, 'Intermediate', 'assets/img/courses-blockchain/DeFi.png', 0, 50),
('nft', 'NFT và Metaverse', 'blockchain', 'NFT, Metaverse và tương lai của Web3', 1499000, 2999000, '16 giờ', 1876, 'Intermediate', 'assets/img/courses-blockchain/NFT.png', 0, 50),
('web3', 'Web3 Development', 'blockchain', 'Phát triển ứng dụng Web3 toàn diện', 2299000, 4599000, '28 giờ', 765, 'Advanced', 'assets/img/courses-blockchain/Web3.png', 0, 50),
('crypto-trading', 'Crypto Trading chuyên nghiệp', 'blockchain', 'Giao dịch tiền điện tử chuyên nghiệp', 1899000, 3799000, '22 giờ', 1234, 'Intermediate', 'assets/img/courses-blockchain/crypto-trading.png', 0, 50);

-- Accounting courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('accounting-basic', 'Kế toán cơ bản', 'accounting', 'Nguyên lý kế toán cho người mới bắt đầu', 699000, 1399000, '10 giờ', 2345, 'Beginner', 'assets/img/courses-accounting/accounting-basic.png', 1, 50),
('accounting-misa', 'Kế toán trên phần mềm MISA', 'accounting', 'Thực hành kế toán với phần mềm MISA', 1299000, 2599000, '16 giờ', 1876, 'Intermediate', 'assets/img/courses-accounting/accounting-misa.png', 0, 50),
('tax-accounting', 'Kế toán thuế', 'accounting', 'Kế toán thuế doanh nghiệp và cá nhân', 1499000, 2999000, '18 giờ', 1543, 'Intermediate', 'assets/img/courses-accounting/tax-accounting.png', 0, 50),
('cost-accounting', 'Kế toán chi phí', 'accounting', 'Kế toán và quản trị chi phí doanh nghiệp', 899000, 1799000, '12 giờ', 1234, 'Intermediate', 'assets/img/courses-accounting/cost-accounting.png', 0, 50),
('excel-accounting', 'Excel cho kế toán', 'accounting', 'Excel nâng cao cho nghề kế toán', 799000, 1599000, '10 giờ', 2134, 'Beginner', 'assets/img/courses-accounting/excel-accounting.png', 0, 50),
('financial-statements', 'Lập và phân tích báo cáo tài chính', 'accounting', 'Lập và phân tích báo cáo tài chính doanh nghiệp', 1399000, 2799000, '16 giờ', 1654, 'Advanced', 'assets/img/courses-accounting/financial-statements.png', 0, 50);

-- Marketing courses (6 courses)
INSERT INTO courses (course_id, course_name, category, description, price, old_price, duration, students_count, level, thumbnail, is_new, discount_percentage) VALUES
('digital-marketing', 'Digital Marketing toàn diện', 'marketing', 'Marketing kỹ thuật số từ A đến Z', 1499000, 2999000, '20 giờ', 3456, 'Beginner', 'assets/img/courses-marketing/digital-marketing.png', 1, 50),
('facebook-ads', 'Facebook Ads chuyên nghiệp', 'marketing', 'Quảng cáo Facebook hiệu quả và tối ưu chi phí', 1299000, 2599000, '16 giờ', 2345, 'Intermediate', 'assets/img/courses-marketing/facebook-ads.png', 0, 50),
('google-ads', 'Google Ads & SEO', 'marketing', 'Quảng cáo Google và tối ưu hóa công cụ tìm kiếm', 1599000, 3199000, '18 giờ', 2134, 'Intermediate', 'assets/img/courses-marketing/google-ads.png', 0, 50),
('content-marketing', 'Content Marketing hiệu quả', 'marketing', 'Xây dựng chiến lược content marketing bài bản', 1199000, 2399000, '14 giờ', 1876, 'Intermediate', 'assets/img/courses-marketing/content-marketing.png', 0, 50),
('social-media', 'Social Media Marketing', 'marketing', 'Marketing trên các nền tảng mạng xã hội', 899000, 1799000, '12 giờ', 2567, 'Beginner', 'assets/img/courses-marketing/social-media.png', 0, 50),
('email-marketing', 'Email Marketing chuyên nghiệp', 'marketing', 'Chiến lược email marketing hiệu quả', 999000, 1999000, '10 giờ', 1654, 'Beginner', 'assets/img/courses-marketing/email-marketing.png', 0, 50);

-- Lessons for finance-basic course
INSERT INTO lessons (course_id, section_id, lesson_title, lesson_content, video_url, duration, lesson_order, is_active) VALUES
('finance-basic', 1, 'LỘ TRÌNH XÂY DỰNG KIẾN THỨC TÀI CHÍNH', 'Nội dung bài học về lộ trình xây dựng kiến thức tài chính cơ bản', 'https://www.youtube.com/watch?v=madrRu_iU6U', '3:11', 1, 1),
('finance-basic', 1, 'BÀI 1: CÁC THUẬT NGỮ TÀI CHÍNH CƠ BẢN CẦN BIẾT', 'Giới thiệu các thuật ngữ tài chính cơ bản mà mọi người cần nắm vững', 'https://www.youtube.com/watch?v=wqcLaQo0m5s', '4:15', 2, 1),
('finance-basic', 1, 'BÀI 2: HIỂU VỀ THỊ TRƯỜNG TÀI CHÍNH', 'Khái niệm và cách thức hoạt động của thị trường tài chính', 'https://www.youtube.com/watch?v=i0-K4fAvlMQ', '5:03', 3, 1),
('finance-basic', 1, 'BÀI 3: BẢN CHẤT CỦA TÍCH LŨY TIỀN BẠC', 'Tìm hiểu về việc tích lũy tài sản và quản lý tiền bạc hiệu quả', 'https://www.youtube.com/watch?v=LBxgRZ04Fvc', '3:55', 4, 1),
('finance-basic', 1, 'BÀI 4: TÍCH LŨY TIỀN NHƯ THẾ NÀO ĐỂ ĐẠT ĐƯỢC HIỆU QUẢ NHẤT?', 'Các phương pháp và chiến lược tích lũy tiền hiệu quả', 'https://www.youtube.com/watch?v=LDV41AlayVw', '5:53', 5, 1),
('finance-basic', 1, 'BÀI 5: ĐẦU TƯ TỪ ĐÂU?', 'Hướng dẫn cơ bản về đầu tư tài chính từ khái niệm đến thực hành', 'https://www.youtube.com/watch?v=ULEMECVelP0', '6:28', 6, 1),
('finance-basic', 1, 'BÀI 6: PHÂN BIỆT CỔ PHIẾU VÀ TRÁI PHIẾU', 'Sự khác nhau giữa cổ phiếu và trái phiếu, ưu nhược điểm của từng loại', 'https://www.youtube.com/watch?v=EVPC25qboNA', '5:53', 7, 1),
('finance-basic', 1, 'BÀI 7: NÊN VỮNG LÝ THUYẾT RỒI MỚI ĐẦU TƯ HAY VỪA HỌC LÝ THUYẾT VỪA ĐẦU TƯ', 'Thảo luận về phương pháp học và thực hành đầu tư hiệu quả', 'https://www.youtube.com/watch?v=KiL4T9kYZDQ', '5:14', 8, 1),
('finance-basic', 1, 'BÀI 8: THẾ NÀO LÀ TIÊU TIỀN ĐÚNG ĐẮN?', 'Nguyên tắc tiêu dùng hợp lý và quản lý chi tiêu cá nhân', 'https://www.youtube.com/watch?v=dEXI-gGyAmI', '6:05', 9, 1),
('finance-basic', 1, 'BÀI 9: PHÁT TRIỂN CÁC CẤP ĐỘ TÀI CHÍNH ĐỂ TRỞ THÀNH NHÀ ĐẦU TƯ CHUYÊN NGHIỆP', 'Hướng dẫn phát triển kỹ năng đầu tư từ cơ bản đến chuyên nghiệp', 'https://www.youtube.com/watch?v=11erHIGnSPo', '5:03', 10, 1),
('finance-basic', 1, 'BÀI 10: 5 BÍ KÍP QUẢN LÝ TÀI CHÍNH SẼ THAY ĐỔI CUỘC SỐNG CỦA BẠN', '5 bí quyết quản lý tài chính hiệu quả thay đổi cuộc sống', 'https://www.youtube.com/watch?v=06yoYByxnrs', 'N/A', 11, 1),
('finance-basic', 1, 'BÀI 11: 5 KÊNH ĐẦU TƯ TÀI CHÍNH BẠN NÊN THỬ MỘT LẦN TRONG ĐỜI', 'Giới thiệu 5 kênh đầu tư tài chính phổ biến và hiệu quả', 'https://www.youtube.com/watch?v=FF8V1azhbaw', '7:53', 12, 1),
('finance-basic', 1, 'BÀI 12: CÁCH LẬP KẾ HOẠCH TÀI CHÍNH CÁ NHÂN TỪ CON SỐ 0 ĐẾN TỰ DO TÀI CHÍNH', 'Hướng dẫn lập kế hoạch tài chính cá nhân toàn diện', 'https://www.youtube.com/watch?v=M_maFKUUYbE', '8:46', 13, 1);

-- Assign all courses to all teachers
INSERT INTO teacher_courses (teacher_id, course_id) 
SELECT u.user_id, c.course_id 
FROM users u 
CROSS JOIN courses c 
WHERE u.email LIKE 'teacher%@ptit.edu.vn';

-- Add sample orders
INSERT INTO orders (user_id, total_amount, payment_method, status) VALUES
((SELECT user_id FROM users WHERE email = 'tranduccuong17@gmail.com'), 1699000, 'vietqr', 'completed'),
((SELECT user_id FROM users WHERE email = 'student1@gmail.com'), 999000, 'credit_card', 'completed');

INSERT INTO order_items (order_id, course_id, price) VALUES
(1, 'investment', 1699000),
(2, 'python-basics', 999000);

INSERT INTO course_progress (user_id, course_id, progress_percentage, status) VALUES
((SELECT user_id FROM users WHERE email = 'tranduccuong17@gmail.com'), 'investment', 25, 'in_progress'),
((SELECT user_id FROM users WHERE email = 'student1@gmail.com'), 'python-basics', 50, 'in_progress');

SET FOREIGN_KEY_CHECKS = 1;

-- Verify
SELECT 'Data imported successfully!' as message;
SELECT COUNT(*) as total_courses FROM courses;
SELECT COUNT(*) as total_users FROM users;
SELECT course_id, course_name FROM courses LIMIT 5;
SELECT email, fullname FROM users LIMIT 5;
