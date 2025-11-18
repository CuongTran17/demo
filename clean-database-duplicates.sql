-- ============================================
-- PTIT LEARNING - Database Cleanup Script
-- Purpose: Remove duplicate records and invalid data
-- ============================================

USE ptit_learning;

-- ============================================
-- 1. CHECK FOR DUPLICATE PURCHASES IN user_courses
-- ============================================
SELECT 
    user_id, 
    course_id, 
    COUNT(*) as duplicate_count
FROM (
    -- Combine data from orders via order_items
    SELECT DISTINCT
        o.user_id,
        oi.course_id
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
) AS user_purchases
GROUP BY user_id, course_id
HAVING COUNT(*) > 1;

-- ============================================
-- 2. CHECK FOR ORPHANED CART ITEMS
-- (Cart items for courses that don't exist)
-- ============================================
SELECT c.*
FROM cart c
LEFT JOIN courses co ON c.course_id = co.course_id
WHERE co.course_id IS NULL;

-- ============================================
-- 3. CHECK FOR ORPHANED COURSE PROGRESS
-- (Progress for courses user hasn't purchased)
-- ============================================
SELECT cp.*
FROM course_progress cp
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.user_id = cp.user_id 
    AND oi.course_id = cp.course_id
    AND o.status = 'completed'
);

-- ============================================
-- 4. CHECK FOR DUPLICATE CART ITEMS
-- (Should be prevented by UNIQUE constraint, but check anyway)
-- ============================================
SELECT 
    user_id,
    course_id,
    COUNT(*) as duplicate_count
FROM cart
GROUP BY user_id, course_id
HAVING COUNT(*) > 1;

-- ============================================
-- 5. CHECK FOR DUPLICATE COURSE PROGRESS
-- (Should be prevented by UNIQUE constraint, but check anyway)
-- ============================================
SELECT 
    user_id,
    course_id,
    COUNT(*) as duplicate_count
FROM course_progress
GROUP BY user_id, course_id
HAVING COUNT(*) > 1;

-- ============================================
-- CLEANUP COMMANDS (Run only if issues found above)
-- ============================================

-- Remove duplicate cart items (keep only the oldest one)
-- DELETE c1 FROM cart c1
-- INNER JOIN cart c2 
-- WHERE c1.user_id = c2.user_id 
-- AND c1.course_id = c2.course_id 
-- AND c1.cart_id > c2.cart_id;

-- Remove orphaned cart items
-- DELETE c FROM cart c
-- LEFT JOIN courses co ON c.course_id = co.course_id
-- WHERE co.course_id IS NULL;

-- Remove orphaned course progress
-- DELETE cp FROM course_progress cp
-- WHERE NOT EXISTS (
--     SELECT 1
--     FROM orders o
--     INNER JOIN order_items oi ON o.order_id = oi.order_id
--     WHERE o.user_id = cp.user_id 
--     AND oi.course_id = cp.course_id
--     AND o.status = 'completed'
-- );

-- Remove duplicate course progress (keep only the one with highest progress)
-- DELETE cp1 FROM course_progress cp1
-- INNER JOIN course_progress cp2 
-- WHERE cp1.user_id = cp2.user_id 
-- AND cp1.course_id = cp2.course_id 
-- AND (cp1.progress_percentage < cp2.progress_percentage 
--      OR (cp1.progress_percentage = cp2.progress_percentage AND cp1.progress_id > cp2.progress_id));

-- ============================================
-- 6. VERIFICATION QUERIES (Run after cleanup)
-- ============================================

-- Count total records in each table
-- SELECT 'users' as table_name, COUNT(*) as record_count FROM users
-- UNION ALL
-- SELECT 'courses', COUNT(*) FROM courses
-- UNION ALL
-- SELECT 'cart', COUNT(*) FROM cart
-- UNION ALL
-- SELECT 'orders', COUNT(*) FROM orders
-- UNION ALL
-- SELECT 'order_items', COUNT(*) FROM order_items
-- UNION ALL
-- SELECT 'course_progress', COUNT(*) FROM course_progress;

-- ============================================
-- 7. CHECK FOR CART ITEMS OF ALREADY PURCHASED COURSES
-- (Should be cleaned up after purchase)
-- ============================================
SELECT c.*
FROM cart c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.user_id = c.user_id 
    AND oi.course_id = c.course_id
    AND o.status = 'completed'
);

-- Remove cart items for already purchased courses
-- DELETE c FROM cart c
-- WHERE EXISTS (
--     SELECT 1
--     FROM orders o
--     INNER JOIN order_items oi ON o.order_id = oi.order_id
--     WHERE o.user_id = c.user_id 
--     AND oi.course_id = c.course_id
--     AND o.status = 'completed'
-- );

-- ============================================
-- NOTES:
-- ============================================
-- 1. Run CHECK queries first to identify issues
-- 2. Review results carefully before running CLEANUP commands
-- 3. Uncomment CLEANUP commands only if duplicates are found
-- 4. Run VERIFICATION queries after cleanup to confirm
-- 5. This script is safe to run multiple times (idempotent)
-- ============================================
