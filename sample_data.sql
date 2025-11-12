-- ============================================
-- SAMPLE DATA FOR TESTING
-- Run this AFTER database_schema.sql
-- ============================================

USE ptit_learning;

-- ============================================
-- Insert Sample Orders for Test User (user_id = 1)
-- ============================================

-- Order 1: Mua 2 khóa (Python Basics + Finance Basics)
INSERT INTO orders (user_id, total_amount, payment_method, status, created_at) VALUES
(1, 2298000, 'cod', 'completed', '2025-10-15 10:30:00');

SET @order1 = LAST_INSERT_ID();

INSERT INTO order_items (order_id, course_id, price) VALUES
(@order1, 'python-basics', 999000),
(@order1, 'finance-basic', 1299000);

-- Order 2: Mua 1 khóa (Python Advanced)
INSERT INTO orders (user_id, total_amount, payment_method, status, created_at) VALUES
(1, 1299000, 'bank', 'completed', '2025-11-01 14:20:00');

SET @order2 = LAST_INSERT_ID();

INSERT INTO order_items (order_id, course_id, price) VALUES
(@order2, 'python-advanced', 1299000);

-- ============================================
-- Insert Sample Course Progress
-- ============================================

INSERT INTO course_progress (user_id, course_id, progress_percentage, total_hours, status) VALUES
(1, 'python-basics', 75, 30.5, 'in_progress'),
(1, 'finance-basic', 100, 45.0, 'completed'),
(1, 'python-advanced', 25, 15.0, 'in_progress');

-- ============================================
-- Verify Data
-- ============================================

SELECT 'Orders Created:' as Info, COUNT(*) as Count FROM orders WHERE user_id = 1;
SELECT 'Order Items Created:' as Info, COUNT(*) as Count FROM order_items;
SELECT 'Progress Records Created:' as Info, COUNT(*) as Count FROM course_progress WHERE user_id = 1;

-- Show detailed info
SELECT 
    o.order_id,
    o.total_amount,
    o.payment_method,
    o.status,
    o.created_at,
    oi.course_id,
    c.course_name,
    oi.price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN courses c ON oi.course_id = c.course_id
WHERE o.user_id = 1
ORDER BY o.created_at DESC;

-- ============================================
-- SUCCESS!
-- Test user (test@ptit.edu.vn / 123456) now has:
-- - 2 completed orders
-- - 3 purchased courses
-- - 3 progress records (1 completed, 2 in progress)
-- ============================================
