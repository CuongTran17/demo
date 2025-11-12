-- Kiểm tra user vừa đăng ký
USE ptit_learning;

-- Xem tất cả users
SELECT user_id, email, phone, fullname, created_at 
FROM users 
ORDER BY created_at DESC 
LIMIT 10;

-- Nếu muốn xem chi tiết user cụ thể (thay YOUR_EMAIL)
-- SELECT * FROM users WHERE email = 'YOUR_EMAIL';
