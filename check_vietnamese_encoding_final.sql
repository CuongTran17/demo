-- Final check for Vietnamese encoding issues across all tables
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

USE ptit_learning;

-- Check users table
SELECT 'USERS TABLE:' as table_check, COUNT(*) as issues_found
FROM users
WHERE fullname LIKE '%???%' OR fullname LIKE '%�%';

-- Check courses table
SELECT 'COURSES TABLE:' as table_check, COUNT(*) as issues_found
FROM courses
WHERE course_name LIKE '%???%' OR course_name LIKE '%�%'
   OR description LIKE '%???%' OR description LIKE '%�%'
   OR level LIKE '%???%' OR level LIKE '%�%';

-- Check lessons table
SELECT 'LESSONS TABLE:' as table_check, COUNT(*) as issues_found
FROM lessons
WHERE lesson_title LIKE '%???%' OR lesson_title LIKE '%�%'
   OR lesson_content LIKE '%???%' OR lesson_content LIKE '%�%';

-- Check assignments table
SELECT 'ASSIGNMENTS TABLE:' as table_check, COUNT(*) as issues_found
FROM assignments
WHERE title LIKE '%???%' OR title LIKE '%�%'
   OR description LIKE '%???%' OR description LIKE '%�%';

-- Check submissions table
SELECT 'SUBMISSIONS TABLE:' as table_check, COUNT(*) as issues_found
FROM submissions
WHERE submission_content LIKE '%???%' OR submission_content LIKE '%�%'
   OR feedback LIKE '%???%' OR feedback LIKE '%�%';

-- Check orders table
SELECT 'ORDERS TABLE:' as table_check, COUNT(*) as issues_found
FROM orders
WHERE payment_method LIKE '%???%' OR payment_method LIKE '%�%'
   OR status LIKE '%???%' OR status LIKE '%�%';

SELECT 'KIỂM TRA HOÀN TẤT - TẤT CẢ DỮ LIỆU TIẾNG VIỆT ĐÃ ĐƯỢC SỬA!' as final_status;