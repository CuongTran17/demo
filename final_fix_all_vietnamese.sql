-- Ultimate fix for ALL Vietnamese text in database
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;
SET CHARACTER SET utf8mb4;
USE ptit_learning;

-- Fix ALL users
UPDATE users SET fullname = 'Nguyễn Văn Python' WHERE email = 'teacher1@ptit.edu.vn';
UPDATE users SET fullname = 'Trần Thị Finance' WHERE email = 'teacher2@ptit.edu.vn';
UPDATE users SET fullname = 'Lê Văn Data' WHERE email = 'teacher3@ptit.edu.vn';
UPDATE users SET fullname = 'Phạm Thị Blockchain' WHERE email = 'teacher4@ptit.edu.vn';
UPDATE users SET fullname = 'Hoàng Văn Accounting' WHERE email = 'teacher5@ptit.edu.vn';
UPDATE users SET fullname = 'Vũ Thị Marketing' WHERE email = 'teacher6@ptit.edu.vn';

-- Fix ALL 36 courses (name + description)
-- Python courses
UPDATE courses SET 
    course_name = 'Procedural Python - Lập trình hàm trong Python',
    description = 'Học lập trình hàm trong Python từ cơ bản đến nâng cao, áp dụng vào dự án thực tế'
WHERE course_id = 'python-procedural';

UPDATE courses SET 
    course_name = 'Python Basics - Lập trình Python cơ bản',
    description = 'Khóa học Python cho người mới bắt đầu, từ zero đến hero'
WHERE course_id = 'python-basics';

UPDATE courses SET 
    course_name = 'Python Toàn Tập - Từ Zero Đến Hero',
    description = 'Khóa học Python toàn diện nhất, bao gồm tất cả kiến thức cần thiết'
WHERE course_id = 'python-complete';

UPDATE courses SET 
    course_name = 'Python Excel cho người đi làm',
    description = 'Tự động hóa Excel bằng Python, tiết kiệm thời gian làm việc'
WHERE course_id = 'python-excel';

UPDATE courses SET 
    course_name = 'Selenium Python - Test Automation',
    description = 'Automation testing với Selenium và Python'
WHERE course_id = 'selenium-python';

UPDATE courses SET 
    course_name = 'Python OOP - Lập trình hướng đối tượng',
    description = 'Lập trình hướng đối tượng với Python, từ cơ bản đến nâng cao'
WHERE course_id = 'python-oop';

-- Finance courses
UPDATE courses SET 
    course_name = 'Tài chính cơ bản',
    description = 'Học các khái niệm tài chính nền tảng, quản lý chi tiêu cá nhân hiệu quả'
WHERE course_id = 'finance-basic';

UPDATE courses SET 
    course_name = 'Đầu tư chứng khoán từ A-Z',
    description = 'Phân tích và chiến lược đầu tư chứng khoán'
WHERE course_id = 'investment';

UPDATE courses SET 
    course_name = 'Nghiệp vụ ngân hàng hiện đại',
    description = 'Khóa học Nghiệp vụ Ngân hàng Thương mại từ TS Lê Thẩm Dương'
WHERE course_id = 'banking';

UPDATE courses SET 
    course_name = 'Tài chính cá nhân thông minh',
    description = 'Hành trình Tự do Tài chính từ A-Z'
WHERE course_id = 'personal-finance';

UPDATE courses SET 
    course_name = 'Trading Forex cho người mới',
    description = 'Khóa học Trading Forex toàn diện từ fxalexg'
WHERE course_id = 'forex';

UPDATE courses SET 
    course_name = 'Phân tích báo cáo tài chính',
    description = 'Khóa học Phân tích báo cáo tài chính toàn diện'
WHERE course_id = 'financial-analysis';

-- Data courses
UPDATE courses SET 
    course_name = 'Data Analytics cơ bản',
    description = 'Khóa học phân tích dữ liệu cho người mới bắt đầu'
WHERE course_id = 'data-basic';

UPDATE courses SET 
    course_name = 'Excel cho Data Analyst',
    description = 'Excel nâng cao cho phân tích dữ liệu'
WHERE course_id = 'excel-data';

UPDATE courses SET 
    course_name = 'SQL cho Data Analyst',
    description = 'Học SQL từ cơ bản đến nâng cao cho Data Analyst'
WHERE course_id = 'sql-data';

UPDATE courses SET 
    course_name = 'Power BI toàn tập',
    description = 'Trực quan hóa dữ liệu với Power BI'
WHERE course_id = 'power-bi';

UPDATE courses SET 
    course_name = 'Python cho Data Science',
    description = 'Python cho phân tích và khoa học dữ liệu'
WHERE course_id = 'python-data';

UPDATE courses SET 
    course_name = 'Tableau Desktop chuyên nghiệp',
    description = 'Trực quan hóa dữ liệu với Tableau'
WHERE course_id = 'tableau';

-- Blockchain courses
UPDATE courses SET 
    course_name = 'Blockchain cơ bản',
    description = 'Kiến thức nền tảng về công nghệ Blockchain'
WHERE course_id = 'blockchain-basic';

UPDATE courses SET 
    course_name = 'Smart Contract với Solidity',
    description = 'Lập trình Smart Contract trên Ethereum'
WHERE course_id = 'smart-contract';

UPDATE courses SET 
    course_name = 'DeFi toàn tập',
    description = 'Tài chính phi tập trung - DeFi từ A đến Z'
WHERE course_id = 'defi';

UPDATE courses SET 
    course_name = 'NFT và Metaverse',
    description = 'NFT, Metaverse và tương lai của Web3'
WHERE course_id = 'nft';

UPDATE courses SET 
    course_name = 'Web3 Development',
    description = 'Phát triển ứng dụng Web3 toàn diện'
WHERE course_id = 'web3';

UPDATE courses SET 
    course_name = 'Crypto Trading chuyên nghiệp',
    description = 'Giao dịch tiền điện tử chuyên nghiệp'
WHERE course_id = 'crypto-trading';

-- Accounting courses
UPDATE courses SET 
    course_name = 'Kế toán cơ bản',
    description = 'Nguyên lý kế toán cho người mới bắt đầu'
WHERE course_id = 'accounting-basic';

UPDATE courses SET 
    course_name = 'Kế toán trên phần mềm MISA',
    description = 'Thực hành kế toán với phần mềm MISA'
WHERE course_id = 'accounting-misa';

UPDATE courses SET 
    course_name = 'Kế toán thuế',
    description = 'Kế toán thuế doanh nghiệp và cá nhân'
WHERE course_id = 'tax-accounting';

UPDATE courses SET 
    course_name = 'Kế toán chi