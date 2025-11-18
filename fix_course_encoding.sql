-- ============================================
-- Fix Course Data Encoding Issues
-- This script fixes the ??? characters in course data
-- ============================================

USE ptit_learning;

-- Set proper charset for the session
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Update course data with proper Vietnamese characters
UPDATE courses SET 
    course_name = 'Ngân hàng hiện đại',
    description = 'Hoạt động ngân hàng và dịch vụ tài chính hiện đại'
WHERE course_id = 'banking';

UPDATE courses SET 
    course_name = 'Blockchain cơ bản',
    description = 'Kiến thức nền tảng về công nghệ Blockchain'
WHERE course_id = 'blockchain-basic';

UPDATE courses SET 
    course_name = 'Kế toán cơ bản',
    description = 'Kiến thức nền tảng về kế toán cho người mới bắt đầu'
WHERE course_id = 'accounting-basic';

UPDATE courses SET 
    course_name = 'Marketing số',
    description = 'Digital Marketing toàn diện từ cơ bản đến nâng cao'
WHERE course_id = 'digital-marketing';

UPDATE courses SET 
    course_name = 'Data Analytics cơ bản',
    description = 'Phân tích dữ liệu cơ bản cho người mới bắt đầu'
WHERE course_id = 'data-basic';

-- Verify the updates
SELECT course_id, course_name, description, category FROM courses WHERE course_name LIKE '%???%' OR description LIKE '%???%';