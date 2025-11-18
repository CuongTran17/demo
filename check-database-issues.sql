-- ============================================
-- KIỂM TRA VẤN ĐỀ DATABASE
-- ============================================

USE ptit_learning;

-- 1. Kiểm tra các khóa học đã mua (qua orders)
SELECT 
    u.user_id,
    u.fullname,
    u.email,
    o.order_id,
    o.created_at as ngay_mua,
    oi.course_id,
    c.course_name
FROM users u
INNER JOIN orders o ON u.user_id = o.user_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN courses c ON oi.course_id = c.course_id
WHERE o.status = 'completed'
ORDER BY u.user_id, o.created_at DESC;

-- 2. Kiểm tra có duplicate purchases không
SELECT 
    u.user_id,
    u.fullname,
    oi.course_id,
    c.course_name,
    COUNT(*) as so_lan_mua
FROM users u
INNER JOIN orders o ON u.user_id = o.user_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN courses c ON oi.course_id = c.course_id
WHERE o.status = 'completed'
GROUP BY u.user_id, oi.course_id, u.fullname, c.course_name
HAVING COUNT(*) > 1;

-- 3. Kiểm tra cart items của user
SELECT 
    u.user_id,
    u.fullname,
    c.course_id,
    c.course_name,
    cart.added_at
FROM cart
INNER JOIN users u ON cart.user_id = u.user_id
INNER JOIN courses c ON cart.course_id = c.course_id
ORDER BY u.user_id, cart.added_at;

-- 4. Kiểm tra cart items cho khóa học đã mua
SELECT 
    u.user_id,
    u.fullname,
    cart.course_id,
    c.course_name,
    'ĐÃ MUA NHƯNG VẪN CÒN TRONG GIỎ HÀNG!' as van_de
FROM cart
INNER JOIN users u ON cart.user_id = u.user_id
INNER JOIN courses c ON cart.course_id = c.course_id
WHERE EXISTS (
    SELECT 1 
    FROM orders o
    INNER JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.user_id = cart.user_id 
    AND oi.course_id = cart.course_id
    AND o.status = 'completed'
);

-- 5. Tổng hợp tình trạng
SELECT 
    'Tổng số users' as thong_ke, 
    COUNT(*) as so_luong 
FROM users
UNION ALL
SELECT 
    'Tổng số orders completed', 
    COUNT(*) 
FROM orders WHERE status = 'completed'
UNION ALL
SELECT 
    'Tổng số items trong cart', 
    COUNT(*) 
FROM cart
UNION ALL
SELECT 
    'Tổng số course đã bán', 
    COUNT(*) 
FROM order_items oi
INNER JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'completed';
