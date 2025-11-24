-- ============================================
-- Verify Sample Data
-- Run this after inserting sample data to check
-- ============================================

USE ptit_learning;

-- Check total courses by category
SELECT 
    category,
    COUNT(*) as total_courses
FROM courses
GROUP BY category
ORDER BY category;

-- Check teacher accounts
SELECT 
    user_id,
    email,
    fullname,
    phone
FROM users
WHERE email LIKE 'teacher%@ptit.edu.vn'
ORDER BY email;

-- Check teacher-course assignments
SELECT 
    u.email as teacher_email,
    u.fullname as teacher_name,
    c.category,
    COUNT(tc.course_id) as assigned_courses
FROM users u
INNER JOIN teacher_courses tc ON u.user_id = tc.teacher_id
INNER JOIN courses c ON tc.course_id = c.course_id
WHERE u.email LIKE 'teacher%@ptit.edu.vn'
GROUP BY u.email, u.fullname, c.category
ORDER BY u.email;

-- Check detailed teacher-course assignments
SELECT 
    u.email as teacher_email,
    u.fullname as teacher_name,
    c.course_id,
    c.course_name,
    c.category
FROM users u
INNER JOIN teacher_courses tc ON u.user_id = tc.teacher_id
INNER JOIN courses c ON tc.course_id = c.course_id
WHERE u.email LIKE 'teacher%@ptit.edu.vn'
ORDER BY u.email, c.category, c.course_id;

-- Verify each teacher has exactly 6 courses
SELECT 
    u.email,
    u.fullname,
    COUNT(tc.course_id) as course_count,
    CASE 
        WHEN COUNT(tc.course_id) = 6 THEN '✓ OK'
        ELSE '✗ ERROR: Should be 6'
    END as status
FROM users u
INNER JOIN teacher_courses tc ON u.user_id = tc.teacher_id
WHERE u.email LIKE 'teacher%@ptit.edu.vn'
GROUP BY u.email, u.fullname
ORDER BY u.email;

-- Verify course IDs match between teachers and courses
SELECT 
    CASE 
        WHEN (SELECT COUNT(*) FROM teacher_courses tc 
              INNER JOIN courses c ON tc.course_id = c.course_id 
              WHERE c.category = 'python') = 6 
        THEN '✓ Python: 6 courses assigned'
        ELSE '✗ Python: ERROR'
    END as python_check
UNION ALL
SELECT 
    CASE 
        WHEN (SELECT COUNT(*) FROM teacher_courses tc 
              INNER JOIN courses c ON tc.course_id = c.course_id 
              WHERE c.category = 'finance') = 6 
        THEN '✓ Finance: 6 courses assigned'
        ELSE '✗ Finance: ERROR'
    END
UNION ALL
SELECT 
    CASE 
        WHEN (SELECT COUNT(*) FROM teacher_courses tc 
              INNER JOIN courses c ON tc.course_id = c.course_id 
              WHERE c.category = 'data') = 6 
        THEN '✓ Data: 6 courses assigned'
        ELSE '✗ Data: ERROR'
    END
UNION ALL
SELECT 
    CASE 
        WHEN (SELECT COUNT(*) FROM teacher_courses tc 
              INNER JOIN courses c ON tc.course_id = c.course_id 
              WHERE c.category = 'blockchain') = 6 
        THEN '✓ Blockchain: 6 courses assigned'
        ELSE '✗ Blockchain: ERROR'
    END
UNION ALL
SELECT 
    CASE 
        WHEN (SELECT COUNT(*) FROM teacher_courses tc 
              INNER JOIN courses c ON tc.course_id = c.course_id 
              WHERE c.category = 'accounting') = 6 
        THEN '✓ Accounting: 6 courses assigned'
        ELSE '✗ Accounting: ERROR'
    END
UNION ALL
SELECT 
    CASE 
        WHEN (SELECT COUNT(*) FROM teacher_courses tc 
              INNER JOIN courses c ON tc.course_id = c.course_id 
              WHERE c.category = 'marketing') = 6 
        THEN '✓ Marketing: 6 courses assigned'
        ELSE '✗ Marketing: ERROR'
    END;
