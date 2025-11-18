-- ============================================
-- RESET USER DATA - Xóa toàn bộ data test
-- ============================================

USE ptit_learning;

-- 1. Xóa toàn bộ dữ liệu course_progress
DELETE FROM course_progress;

-- 2. Xóa toàn bộ dữ liệu cart
DELETE FROM cart;

-- 3. Xóa toàn bộ order_items
DELETE FROM order_items;

-- 4. Xóa toàn bộ orders
DELETE FROM orders;

-- 5. Reset AUTO_INCREMENT
ALTER TABLE course_progress AUTO_INCREMENT = 1;
ALTER TABLE cart AUTO_INCREMENT = 1;
ALTER TABLE order_items AUTO_INCREMENT = 1;
ALTER TABLE orders AUTO_INCREMENT = 1;

-- 6. Verify - Kiểm tra đã xóa sạch
SELECT 'course_progress' as bang, COUNT(*) as so_dong FROM course_progress
UNION ALL
SELECT 'cart', COUNT(*) FROM cart
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'orders', COUNT(*) FROM orders;

-- ============================================
-- KẾT QUẢ: Tất cả users giờ như mới tạo
-- - Không có khóa học đã mua
-- - Không có giỏ hàng
-- - Không có lịch sử đơn hàng
-- - Không có tiến độ học tập
-- ============================================
