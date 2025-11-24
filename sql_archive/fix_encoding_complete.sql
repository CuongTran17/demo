-- FINAL FIX: Convert all double-encoded data back to proper UTF-8
SET NAMES utf8mb4;
USE ptit_learning;

-- The data is currently stored as latin1 bytes of UTF-8 text
-- We need to convert it back to proper UTF-8

-- Fix courses table
UPDATE courses SET course_name = CONVERT(CAST(CONVERT(course_name USING latin1) AS BINARY) USING utf8mb4);
UPDATE courses SET description = CONVERT(CAST(CONVERT(description USING latin1) AS BINARY) USING utf8mb4);

-- Fix users table  
UPDATE users SET fullname = CONVERT(CAST(CONVERT(fullname USING latin1) AS BINARY) USING utf8mb4);

-- Fix lessons table
UPDATE lessons SET lesson_title = CONVERT(CAST(CONVERT(lesson_title USING latin1) AS BINARY) USING utf8mb4);
UPDATE lessons SET lesson_content = CONVERT(CAST(CONVERT(lesson_content USING latin1) AS BINARY) USING utf8mb4);

-- Verify
SELECT 'Courses:' as table_name, course_id, course_name FROM courses LIMIT 3;
SELECT 'Users:' as table_name, email, fullname FROM users LIMIT 3;
SELECT 'Lessons:' as table_name, lesson_id, lesson_title FROM lessons LIMIT 3;
