-- Fix Vietnamese for courses - individual updates
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

USE ptit_learning;

-- Accounting courses
UPDATE courses SET course_name = 'Kế toán cơ bản', description = 'Kiến thức kế toán nền tảng' WHERE course_id = 'accounting-basic';
UPDATE courses SET course_name = 'Kế toán trên phần mềm MISA', description = 'Sử dụng phần mềm MISA trong kế toán' WHERE course_id = 'accounting-misa';
UPDATE courses SET course_name = 'Kế toán chi phí', description = 'Quản lý và hạch toán chi phí' WHERE course_id = 'cost-accounting';
UPDATE courses SET course_name = 'Excel cho kế toán', description = 'Ứng dụng Excel trong công việc kế toán' WHERE course_id = 'excel-accounting';
UPDATE courses SET course_name = 'Lập và phân tích báo cáo tài chính', description = 'Kỹ năng lập và đọc báo cáo tài chính' WHERE course_id = 'financial-statements';
UPDATE courses SET course_name = 'Kế toán thuế', description = 'Kế toán thuế doanh nghiệp' WHERE course_id = 'tax-accounting';

-- Blockchain courses
UPDATE courses SET course_name = 'Blockchain cơ bản', description = 'Hiểu về công nghệ Blockchain' WHERE course_id = 'blockchain-basic';
UPDATE courses SET course_name = 'Crypto Trading chuyên nghiệp', description = 'Giao dịch tiền mã hóa chuyên nghiệp' WHERE course_id = 'crypto-trading';
UPDATE courses SET course_name = 'DeFi toàn tập', description = 'Tài chính phi tập trung DeFi' WHERE course_id = 'defi';
UPDATE courses SET course_name = 'NFT và Metaverse', description = 'NFT và thế giới Metaverse' WHERE course_id = 'nft';
UPDATE courses SET course_name = 'Smart Contract với Solidity', description = 'Lập trình smart contract trên Ethereum' WHERE course_id = 'smart-contract';
UPDATE courses SET course_name = 'Web3 Development', description = 'Phát triển ứng dụng Web3' WHERE course_id = 'web3';

-- Data courses
UPDATE courses SET course_name = 'Data Analytics cơ bản', description = 'Phân tích dữ liệu cho người mới bắt đầu' WHERE course_id = 'data-basic';
UPDATE courses SET course_name = 'Excel cho Data Analyst', description = 'Sử dụng Excel trong phân tích dữ liệu' WHERE course_id = 'excel-data';
UPDATE courses SET course_name = 'SQL cho Data Analyst', description = 'Truy vấn và quản lý dữ liệu với SQL' WHERE course_id = 'sql-data';
UPDATE courses SET course_name = 'Power BI toàn tập', description = 'Trực quan hóa dữ liệu với Power BI' WHERE course_id = 'power-bi';
UPDATE courses SET course_name = 'Python cho Data Science', description = 'Phân tích dữ liệu với Python' WHERE course_id = 'python-data';
UPDATE courses SET course_name = 'Tableau Desktop chuyên nghiệp', description = 'Làm chủ Tableau để trực quan hóa dữ liệu' WHERE course_id = 'tableau';

-- Finance courses
UPDATE courses SET course_name = 'Tài chính cơ bản', description = 'Kiến thức tài chính cơ bản cho mọi người' WHERE course_id = 'finance-basic';
UPDATE courses SET course_name = 'Đầu tư chứng khoán từ A-Z', description = 'Hướng dẫn đầu tư chứng khoán toàn diện' WHERE course_id = 'investment';
UPDATE courses SET course_name = 'Nghiệp vụ ngân hàng hiện đại', description = 'Các nghiệp vụ ngân hàng trong thời đại 4.0' WHERE course_id = 'banking';
UPDATE courses SET course_name = 'Tài chính cá nhân thông minh', description = 'Quản lý tài chính cá nhân hiệu quả' WHERE course_id = 'personal-finance';
UPDATE courses SET course_name = 'Trading Forex cho người mới', description = 'Giao dịch ngoại hối cho người mới bắt đầu' WHERE course_id = 'forex';
UPDATE courses SET course_name = 'Phân tích báo cáo tài chính', description = 'Đọc và phân tích báo cáo tài chính doanh nghiệp' WHERE course_id = 'financial-analysis';

-- Marketing courses
UPDATE courses SET course_name = 'Digital Marketing toàn diện', description = 'Marketing số toàn diện từ A-Z' WHERE course_id = 'digital-marketing';
UPDATE courses SET course_name = 'Facebook Ads chuyên nghiệp', description = 'Quảng cáo Facebook hiệu quả' WHERE course_id = 'facebook-ads';
UPDATE courses SET course_name = 'Google Ads & SEO', description = 'Quảng cáo Google và tối ưu hóa SEO' WHERE course_id = 'google-ads';
UPDATE courses SET course_name = 'Content Marketing hiệu quả', description = 'Xây dựng nội dung marketing thu hút' WHERE course_id = 'content-marketing';
UPDATE courses SET course_name = 'Email Marketing chuyên nghiệp', description = 'Chiến lược email marketing hiệu quả' WHERE course_id = 'email-marketing';
UPDATE courses SET course_name = 'Social Media Marketing', description = 'Marketing trên mạng xã hội' WHERE course_id = 'social-media';

-- Python courses
UPDATE courses SET course_name = 'Python Basics - Lập trình Python cơ bản', description = 'Khóa học Python cơ bản dành cho người mới bắt đầu' WHERE course_id = 'python-basics';
UPDATE courses SET course_name = 'Python Toàn Tập - Từ Zero Đến Hero', description = 'Khóa học Python toàn diện từ cơ bản đến nâng cao' WHERE course_id = 'python-complete';
UPDATE courses SET course_name = 'Python OOP - Lập trình hướng đối tượng', description = 'Học lập trình hướng đối tượng với Python' WHERE course_id = 'python-oop';
UPDATE courses SET course_name = 'Procedural Python - Lập trình hàm trong Python', description = 'Lập trình theo hướng thủ tục với Python' WHERE course_id = 'python-procedural';
UPDATE courses SET course_name = 'Python Excel cho người đi làm', description = 'Tự động hóa Excel với Python' WHERE course_id = 'python-excel';
UPDATE courses SET course_name = 'Selenium Python - Test Automation', description = 'Tự động hóa testing với Selenium Python' WHERE course_id = 'selenium-python';

SELECT 'HOÀN THÀNH SỬA TẤT CẢ COURSES!' as status;