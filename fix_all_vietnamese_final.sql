-- Fix Vietnamese encoding for ALL tables in ptit_learning database
-- This script updates all Vietnamese text with proper UTF-8 characters

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

USE ptit_learning;

-- ============================================
-- FIX COURSES TABLE (36 courses)
-- ============================================

-- Python Courses (6 courses)
UPDATE courses SET course_name = 'Procedural Python - Lập trình hàm trong Python' WHERE course_id = 'python-procedural';
UPDATE courses SET course_name = 'Python Basics - Lập trình Python cơ bản' WHERE course_id = 'python-basics';
UPDATE courses SET course_name = 'Python Toàn Tập - Từ Zero Đến Hero' WHERE course_id = 'python-complete';
UPDATE courses SET course_name = 'Python Excel cho người đi làm' WHERE course_id = 'python-excel';
UPDATE courses SET course_name = 'Selenium Python - Test Automation' WHERE course_id = 'selenium-python';
UPDATE courses SET course_name = 'Python OOP - Lập trình hướng đối tượng' WHERE course_id = 'python-oop';

UPDATE courses SET description = 'Học lập trình hàm trong Python từ cơ bản đến nâng cao, áp dụng vào dự án thực tế' WHERE course_id = 'python-procedural';
UPDATE courses SET description = 'Khóa học Python cho người mới bắt đầu, từ zero đến hero' WHERE course_id = 'python-basics';
UPDATE courses SET description = 'Khóa học Python toàn diện nhất, bao gồm tất cả kiến thức cần thiết' WHERE course_id = 'python-complete';
UPDATE courses SET description = 'Tự động hóa Excel bằng Python, tiết kiệm thời gian làm việc' WHERE course_id = 'python-excel';
UPDATE courses SET description = 'Automation testing với Selenium và Python' WHERE course_id = 'selenium-python';
UPDATE courses SET description = 'Lập trình hướng đối tượng với Python, từ cơ bản đến nâng cao' WHERE course_id = 'python-oop';

-- Finance Courses (6 courses)
UPDATE courses SET course_name = 'Tài chính cơ bản' WHERE course_id = 'finance-basic';
UPDATE courses SET course_name = 'Đầu tư chứng khoán từ A-Z' WHERE course_id = 'investment';
UPDATE courses SET course_name = 'Nghiệp vụ ngân hàng hiện đại' WHERE course_id = 'banking';
UPDATE courses SET course_name = 'Tài chính cá nhân thông minh' WHERE course_id = 'personal-finance';
UPDATE courses SET course_name = 'Trading Forex cho người mới' WHERE course_id = 'forex';
UPDATE courses SET course_name = 'Phân tích báo cáo tài chính' WHERE course_id = 'financial-analysis';

UPDATE courses SET description = 'Học các khái niệm tài chính nền tảng, quản lý chi tiêu cá nhân hiệu quả' WHERE course_id = 'finance-basic';
UPDATE courses SET description = 'Phân tích và chiến lược đầu tư chứng khoán' WHERE course_id = 'investment';
UPDATE courses SET description = 'Khóa học Nghiệp vụ Ngân hàng Thương mại từ TS Lê Thẩm Dương' WHERE course_id = 'banking';
UPDATE courses SET description = 'Hành trình Tự do Tài chính từ A-Z' WHERE course_id = 'personal-finance';
UPDATE courses SET description = 'Khóa học Trading Forex toàn diện từ fxalexg' WHERE course_id = 'forex';
UPDATE courses SET description = 'Khóa học Phân tích báo cáo tài chính toàn diện' WHERE course_id = 'financial-analysis';

-- Data Analyst Courses (6 courses)
UPDATE courses SET course_name = 'Data Analytics cơ bản' WHERE course_id = 'data-basic';
UPDATE courses SET course_name = 'Excel cho Data Analyst' WHERE course_id = 'excel-data';
UPDATE courses SET course_name = 'SQL cho Data Analyst' WHERE course_id = 'sql-data';
UPDATE courses SET course_name = 'Power BI toàn tập' WHERE course_id = 'power-bi';
UPDATE courses SET course_name = 'Python cho Data Science' WHERE course_id = 'python-data';
UPDATE courses SET course_name = 'Tableau Desktop chuyên nghiệp' WHERE course_id = 'tableau';

UPDATE courses SET description = 'Khóa học phân tích dữ liệu cho người mới bắt đầu' WHERE course_id = 'data-basic';
UPDATE courses SET description = 'Excel nâng cao cho phân tích dữ liệu' WHERE course_id = 'excel-data';
UPDATE courses SET description = 'Học SQL từ cơ bản đến nâng cao cho Data Analyst' WHERE course_id = 'sql-data';
UPDATE courses SET description = 'Trực quan hóa dữ liệu với Power BI' WHERE course_id = 'power-bi';
UPDATE courses SET description = 'Python cho phân tích và khoa học dữ liệu' WHERE course_id = 'python-data';
UPDATE courses SET description = 'Trực quan hóa dữ liệu với Tableau' WHERE course_id = 'tableau';

-- Blockchain Courses (6 courses)
UPDATE courses SET course_name = 'Blockchain cơ bản' WHERE course_id = 'blockchain-basic';
UPDATE courses SET course_name = 'Smart Contract với Solidity' WHERE course_id = 'smart-contract';
UPDATE courses SET course_name = 'DeFi toàn tập' WHERE course_id = 'defi';
UPDATE courses SET course_name = 'NFT và Metaverse' WHERE course_id = 'nft';
UPDATE courses SET course_name = 'Web3 Development' WHERE course_id = 'web3';
UPDATE courses SET course_name = 'Crypto Trading chuyên nghiệp' WHERE course_id = 'crypto-trading';

UPDATE courses SET description = 'Kiến thức nền tảng về công nghệ Blockchain' WHERE course_id = 'blockchain-basic';
UPDATE courses SET description = 'Lập trình Smart Contract trên Ethereum' WHERE course_id = 'smart-contract';
UPDATE courses SET description = 'Tài chính phi tập trung - DeFi từ A đến Z' WHERE course_id = 'defi';
UPDATE courses SET description = 'NFT, Metaverse và tương lai của Web3' WHERE course_id = 'nft';
UPDATE courses SET description = 'Phát triển ứng dụng Web3 toàn diện' WHERE course_id = 'web3';
UPDATE courses SET description = 'Giao dịch tiền điện tử chuyên nghiệp' WHERE course_id = 'crypto-trading';

-- Accounting Courses (6 courses)
UPDATE courses SET course_name = 'Kế toán cơ bản' WHERE course_id = 'accounting-basic';
UPDATE courses SET course_name = 'Kế toán trên phần mềm MISA' WHERE course_id = 'accounting-misa';
UPDATE courses SET course_name = 'Kế toán thuế' WHERE course_id = 'tax-accounting';
UPDATE courses SET course_name = 'Kế toán chi phí' WHERE course_id = 'cost-accounting';
UPDATE courses SET course_name = 'Excel cho kế toán' WHERE course_id = 'excel-accounting';
UPDATE courses SET course_name = 'Lập và phân tích báo cáo tài chính' WHERE course_id = 'financial-statements';

UPDATE courses SET description = 'Nguyên lý kế toán cho người mới bắt đầu' WHERE course_id = 'accounting-basic';
UPDATE courses SET description = 'Thực hành kế toán với phần mềm MISA' WHERE course_id = 'accounting-misa';
UPDATE courses SET description = 'Kế toán thuế doanh nghiệp và cá nhân' WHERE course_id = 'tax-accounting';
UPDATE courses SET description = 'Kế toán và quản trị chi phí doanh nghiệp' WHERE course_id = 'cost-accounting';
UPDATE courses SET description = 'Excel nâng cao cho nghề kế toán' WHERE course_id = 'excel-accounting';
UPDATE courses SET description = 'Lập và phân tích báo cáo tài chính doanh nghiệp' WHERE course_id = 'financial-statements';

-- Marketing Courses (6 courses)
UPDATE courses SET course_name = 'Digital Marketing toàn diện' WHERE course_id = 'digital-marketing';
UPDATE courses SET course_name = 'Facebook Ads chuyên nghiệp' WHERE course_id = 'facebook-ads';
UPDATE courses SET course_name = 'Google Ads & SEO' WHERE course_id = 'google-ads';
UPDATE courses SET course_name = 'Content Marketing hiệu quả' WHERE course_id = 'content-marketing';
UPDATE courses SET course_name = 'Social Media Marketing' WHERE course_id = 'social-media';
UPDATE courses SET course_name = 'Email Marketing chuyên nghiệp' WHERE course_id = 'email-marketing';

UPDATE courses SET description = 'Marketing kỹ thuật số từ A đến Z' WHERE course_id = 'digital-marketing';
UPDATE courses SET description = 'Quảng cáo Facebook hiệu quả và tối ưu chi phí' WHERE course_id = 'facebook-ads';
UPDATE courses SET description = 'Quảng cáo Google và tối ưu hóa công cụ tìm kiếm' WHERE course_id = 'google-ads';
UPDATE courses SET description = 'Xây dựng chiến lược content marketing bài bản' WHERE course_id = 'content-marketing';
UPDATE courses SET description = 'Marketing trên các nền tảng mạng xã hội' WHERE course_id = 'social-media';
UPDATE courses SET description = 'Chiến lược email marketing hiệu quả' WHERE course_id = 'email-marketing';

-- ============================================
-- FIX USERS TABLE
-- ============================================
UPDATE users SET fullname = 'Administrator' WHERE email = 'admin@ptit.edu.vn';
UPDATE users SET fullname = 'Nguyễn Văn Python' WHERE email = 'teacher1@ptit.edu.vn';
UPDATE users SET fullname = 'Trần Thị Finance' WHERE email = 'teacher2@ptit.edu.vn';
UPDATE users SET fullname = 'Lê Văn Data' WHERE email = 'teacher3@ptit.edu.vn';
UPDATE users SET fullname = 'Phạm Thị Blockchain' WHERE email = 'teacher4@ptit.edu.vn';
UPDATE users SET fullname = 'Hoàng Văn Accounting' WHERE email = 'teacher5@ptit.edu.vn';
UPDATE users SET fullname = 'Vũ Thị Marketing' WHERE email = 'teacher6@ptit.edu.vn';
UPDATE users SET fullname = 'Trần Đức Cường' WHERE email = 'tranduccuong17@gmail.com';
UPDATE users SET fullname = 'Trần Thị Mai' WHERE email = 'student1@gmail.com';

-- ============================================
-- FIX LESSONS TABLE
-- ============================================
UPDATE lessons SET lesson_title = 'LỘ TRÌNH XÂY DỰNG KIẾN THỨC TÀI CHÍNH' WHERE course_id = 'finance-basic' AND lesson_order = 1;
UPDATE lessons SET lesson_title = 'BÀI 1: CÁC THUẬT NGỮ TÀI CHÍNH CƠ BẢN CẦN BIẾT' WHERE course_id = 'finance-basic' AND lesson_order = 2;
UPDATE lessons SET lesson_title = 'BÀI 2: HIỂU VỀ THỊ TRƯỜNG TÀI CHÍNH' WHERE course_id = 'finance-basic' AND lesson_order = 3;
UPDATE lessons SET lesson_title = 'BÀI 3: BẢN CHẤT CỦA TÍCH LŨY TIỀN BẠC' WHERE course_id = 'finance-basic' AND lesson_order = 4;
UPDATE lessons SET lesson_title = 'BÀI 4: TÍCH LŨY TIỀN NHƯ THẾ NÀO ĐỂ ĐẠT ĐƯỢC HIỆU QUẢ NHẤT?' WHERE course_id = 'finance-basic' AND lesson_order = 5;
UPDATE lessons SET lesson_title = 'BÀI 5: ĐẦU TƯ TỪ ĐÂU?' WHERE course_id = 'finance-basic' AND lesson_order = 6;
UPDATE lessons SET lesson_title = 'BÀI 6: PHÂN BIỆT CỔ PHIẾU VÀ TRÁI PHIẾU' WHERE course_id = 'finance-basic' AND lesson_order = 7;
UPDATE lessons SET lesson_title = 'BÀI 7: NÊN VỮNG LÝ THUYẾT RỒI MỚI ĐẦU TƯ HAY VỪA HỌC LÝ THUYẾT VỪA ĐẦU TƯ' WHERE course_id = 'finance-basic' AND lesson_order = 8;
UPDATE lessons SET lesson_title = 'BÀI 8: THẾ NÀO LÀ TIÊU TIỀN ĐÚNG ĐẮN?' WHERE course_id = 'finance-basic' AND lesson_order = 9;
UPDATE lessons SET lesson_title = 'BÀI 9: PHÁT TRIỂN CÁC CẤP ĐỘ TÀI CHÍNH ĐỂ TRỞ THÀNH NHÀ ĐẦU TƯ CHUYÊN NGHIỆP' WHERE course_id = 'finance-basic' AND lesson_order = 10;
UPDATE lessons SET lesson_title = 'BÀI 10: 5 BÍ KÍP QUẢN LÝ TÀI CHÍNH SẼ THAY ĐỔI CUỘC SỐNG CỦA BẠN' WHERE course_id = 'finance-basic' AND lesson_order = 11;
UPDATE lessons SET lesson_title = 'BÀI 11: 5 KÊNH ĐẦU TƯ TÀI CHÍNH BẠN NÊN THỬ MỘT LẦN TRONG ĐỜI' WHERE course_id = 'finance-basic' AND lesson_order = 12;
UPDATE lessons SET lesson_title = 'BÀI 12: CÁCH LẬP KẾ HOẠCH TÀI CHÍNH CÁ NHÂN TỪ CON SỐ 0 ĐẾN TỰ DO TÀI CHÍNH' WHERE course_id = 'finance-basic' AND lesson_order = 13;

UPDATE lessons SET lesson_content = 'Nội dung bài học về lộ trình xây dựng kiến thức tài chính cơ bản' WHERE course_id = 'finance-basic' AND lesson_order = 1;
UPDATE lessons SET lesson_content = 'Giới thiệu các thuật ngữ tài chính cơ bản mà mọi người cần nắm vững' WHERE course_id = 'finance-basic' AND lesson_order = 2;
UPDATE lessons SET lesson_content = 'Khái niệm và cách thức hoạt động của thị trường tài chính' WHERE course_id = 'finance-basic' AND lesson_order = 3;
UPDATE lessons SET lesson_content = 'Tìm hiểu về việc tích lũy tài sản và quản lý tiền bạc hiệu quả' WHERE course_id = 'finance-basic' AND lesson_order = 4;
UPDATE lessons SET lesson_content = 'Các phương pháp và chiến lược tích lũy tiền hiệu quả' WHERE course_id = 'finance-basic' AND lesson_order = 5;
UPDATE lessons SET lesson_content = 'Hướng dẫn cơ bản về đầu tư tài chính từ khái niệm đến thực hành' WHERE course_id = 'finance-basic' AND lesson_order = 6;
UPDATE lessons SET lesson_content = 'Sự khác nhau giữa cổ phiếu và trái phiếu, ưu nhược điểm của từng loại' WHERE course_id = 'finance-basic' AND lesson_order = 7;
UPDATE lessons SET lesson_content = 'Thảo luận về phương pháp học và thực hành đầu tư hiệu quả' WHERE course_id = 'finance-basic' AND lesson_order = 8;
UPDATE lessons SET lesson_content = 'Nguyên tắc tiêu dùng hợp lý và quản lý chi tiêu cá nhân' WHERE course_id = 'finance-basic' AND lesson_order = 9;
UPDATE lessons SET lesson_content = 'Hướng dẫn phát triển kỹ năng đầu tư từ cơ bản đến chuyên nghiệp' WHERE course_id = 'finance-basic' AND lesson_order = 10;
UPDATE lessons SET lesson_content = '5 bí quyết quản lý tài chính hiệu quả thay đổi cuộc sống' WHERE course_id = 'finance-basic' AND lesson_order = 11;
UPDATE lessons SET lesson_content = 'Giới thiệu 5 kênh đầu tư tài chính phổ biến và hiệu quả' WHERE course_id = 'finance-basic' AND lesson_order = 12;
UPDATE lessons SET lesson_content = 'Hướng dẫn lập kế hoạch tài chính cá nhân toàn diện' WHERE course_id = 'finance-basic' AND lesson_order = 13;

-- ============================================
-- FIX COURSE THUMBNAILS (Update to correct paths)
-- ============================================

-- Python courses
UPDATE courses SET thumbnail = 'assets/img/courses-python/python.png' WHERE course_id IN ('python-procedural', 'python-basics', 'python-complete', 'python-excel', 'selenium-python', 'python-oop');

-- Finance courses  
UPDATE courses SET thumbnail = 'assets/img/courses-finance/Tài chính cơ bản.png' WHERE course_id = 'finance-basic';
UPDATE courses SET thumbnail = 'assets/img/courses-finance/Đầu tư chứng khoán.png' WHERE course_id = 'investment';
UPDATE courses SET thumbnail = 'assets/img/courses-finance/Ngân hàng.png' WHERE course_id = 'banking';
UPDATE courses SET thumbnail = 'assets/img/courses-finance/Tài chính cá nhân.png' WHERE course_id = 'personal-finance';
UPDATE courses SET thumbnail = 'assets/img/courses-finance/Forex.png' WHERE course_id = 'forex';
UPDATE courses SET thumbnail = 'assets/img/courses-finance/Phân tích tài chính.png' WHERE course_id = 'financial-analysis';

-- Data courses
UPDATE courses SET thumbnail = 'assets/img/courses-data/data-analytics.png' WHERE course_id IN ('data-basic', 'excel-data', 'sql-data', 'power-bi', 'python-data', 'tableau');

-- Blockchain courses
UPDATE courses SET thumbnail = 'assets/img/courses-blockchain/blockchain.png' WHERE course_id IN ('blockchain-basic', 'smart-contract', 'defi', 'nft', 'web3', 'crypto-trading');

-- Accounting courses
UPDATE courses SET thumbnail = 'assets/img/courses-accounting/kế toán cơ bản.png' WHERE course_id IN ('accounting-basic', 'accounting-misa', 'tax-accounting', 'cost-accounting', 'excel-accounting', 'financial-statements');

-- Marketing courses
UPDATE courses SET thumbnail = 'assets/img/courses-marketing/marketing.png' WHERE course_id IN ('digital-marketing', 'facebook-ads', 'google-ads', 'content-marketing', 'social-media', 'email-marketing');

-- Verification queries
SELECT 'Encoding check - should be 0:' as message;
SELECT COUNT(*) as encoding_issues FROM courses WHERE course_name LIKE '%?%' OR description LIKE '%?%';

SELECT 'Total courses fixed:' as message;
SELECT COUNT(*) as total_courses FROM courses;

SELECT 'Sample courses:' as message;
SELECT course_id, course_name, thumbnail FROM courses LIMIT 5;
