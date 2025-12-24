-- ============================================
-- PTIT LEARNING - DỮ LIỆU MẪU ĐƠN HÀNG
-- Insert dữ liệu mẫu cho đơn hàng
-- Encoding: UTF-8
-- ============================================

USE ptit_learning;

-- ============================================
-- Insert đơn hàng mẫu
-- ============================================

-- Đơn hàng 1: User test@ptit.edu.vn mua 2 khóa học Python
INSERT INTO orders (user_id, total_amount, payment_method, order_note, status, created_at) VALUES
((SELECT user_id FROM users WHERE email = 'test@ptit.edu.vn'), 2299000, 'credit_card', 'Khóa học Python cho người mới', 'completed', '2024-12-20 10:00:00');

SET @order_id_1 = LAST_INSERT_ID();

INSERT INTO order_items (order_id, course_id, price) VALUES
(@order_id_1, 'python-basics', 999000),
(@order_id_1, 'python-procedural', 1299000);

-- Đơn hàng 2: User test@ptit.edu.vn mua khóa học kế toán
INSERT INTO orders (user_id, total_amount, payment_method, order_note, status, created_at) VALUES
((SELECT user_id FROM users WHERE email = 'test@ptit.edu.vn'), 699000, 'bank_transfer', 'Khóa học kế toán cơ bản', 'completed', '2024-12-21 14:30:00');

SET @order_id_2 = LAST_INSERT_ID();

INSERT INTO order_items (order_id, course_id, price) VALUES
(@order_id_2, 'accounting-basic', 699000);

-- Đơn hàng 3: User test@ptit.edu.vn mua khóa học marketing
INSERT INTO orders (user_id, total_amount, payment_method, order_note, status, created_at) VALUES
((SELECT user_id FROM users WHERE email = 'test@ptit.edu.vn'), 1499000, 'credit_card', 'Digital marketing toàn diện', 'completed', '2024-12-22 16:45:00');

SET @order_id_3 = LAST_INSERT_ID();

INSERT INTO order_items (order_id, course_id, price) VALUES
(@order_id_3, 'digital-marketing', 1499000);

-- Đơn hàng 4: Đơn hàng đang xử lý
INSERT INTO orders (user_id, total_amount, payment_method, order_note, status, created_at) VALUES
((SELECT user_id FROM users WHERE email = 'test@ptit.edu.vn'), 1599000, 'paypal', 'Khóa học Selenium Python', 'pending', '2024-12-24 09:15:00');

SET @order_id_4 = LAST_INSERT_ID();

INSERT INTO order_items (order_id, course_id, price) VALUES
(@order_id_4, 'selenium-python', 1599000);

-- Đơn hàng 5: Đơn hàng đã hủy
INSERT INTO orders (user_id, total_amount, payment_method, order_note, status, created_at) VALUES
((SELECT user_id FROM users WHERE email = 'test@ptit.edu.vn'), 799000, 'credit_card', 'Excel cho kế toán', 'cancelled', '2024-12-23 11:20:00');

SET @order_id_5 = LAST_INSERT_ID();

INSERT INTO order_items (order_id, course_id, price) VALUES
(@order_id_5, 'excel-accounting', 799000);

-- Đơn hàng 6: Đơn hàng từ teacher1@ptit.edu.vn
INSERT INTO orders (user_id, total_amount, payment_method, order_note, status, created_at) VALUES
((SELECT user_id FROM users WHERE email = 'teacher1@ptit.edu.vn'), 1199000, 'bank_transfer', 'Khóa học Python OOP', 'completed', '2024-12-19 13:00:00');

SET @order_id_6 = LAST_INSERT_ID();

INSERT INTO order_items (order_id, course_id, price) VALUES
(@order_id_6, 'python-oop', 1199000);

-- Đơn hàng 7: Đơn hàng từ teacher2@ptit.edu.vn
INSERT INTO orders (user_id, total_amount, payment_method, order_note, status, created_at) VALUES
((SELECT user_id FROM users WHERE email = 'teacher2@ptit.edu.vn'), 1299000, 'credit_card', 'Kế toán trên MISA', 'completed', '2024-12-18 15:30:00');

SET @order_id_7 = LAST_INSERT_ID();

INSERT INTO order_items (order_id, course_id, price) VALUES
(@order_id_7, 'accounting-misa', 1299000);

-- Đơn hàng 8: Đơn hàng combo (nhiều khóa học)
INSERT INTO orders (user_id, total_amount, payment_method, order_note, status, created_at) VALUES
((SELECT user_id FROM users WHERE email = 'test@ptit.edu.vn'), 3199000, 'credit_card', 'Combo khóa học Python và Marketing', 'completed', '2024-12-17 12:00:00');

SET @order_id_8 = LAST_INSERT_ID();

INSERT INTO order_items (order_id, course_id, price) VALUES
(@order_id_8, 'python-complete', 2499000),
(@order_id_8, 'social-media', 899000);

-- Đơn hàng 9: Đơn hàng với giảm giá
INSERT INTO orders (user_id, total_amount, payment_method, order_note, status, created_at) VALUES
((SELECT user_id FROM users WHERE email = 'teacher3@ptit.edu.vn'), 899000, 'paypal', 'Khóa học kế toán chi phí', 'completed', '2024-12-16 10:45:00');

SET @order_id_9 = LAST_INSERT_ID();

INSERT INTO order_items (order_id, course_id, price) VALUES
(@order_id_9, 'cost-accounting', 899000);

-- Đơn hàng 10: Đơn hàng gần đây
INSERT INTO orders (user_id, total_amount, payment_method, order_note, status, created_at) VALUES
((SELECT user_id FROM users WHERE email = 'teacher4@ptit.edu.vn'), 1399000, 'bank_transfer', 'Lập báo cáo tài chính', 'processing', '2024-12-24 08:00:00');

SET @order_id_10 = LAST_INSERT_ID();

INSERT INTO order_items (order_id, course_id, price) VALUES
(@order_id_10, 'financial-statements', 1399000);

-- ============================================
-- Hoàn tất insert dữ liệu mẫu đơn hàng
-- ============================================
SELECT 'Sample orders inserted successfully!' AS status;
SELECT COUNT(*) AS total_orders FROM orders;
SELECT COUNT(*) AS total_order_items FROM order_items;