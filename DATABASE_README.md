# PTIT LEARNING - Database Setup Guide

## 📋 Mục lục
1. [Cài đặt Database](#cài-đặt-database)
2. [Cấu trúc Database](#cấu-trúc-database)
3. [Import Database](#import-database)
4. [Tài khoản Test](#tài-khoản-test)
5. [Troubleshooting](#troubleshooting)

---

## 🚀 Cài đặt Database

### Bước 1: Import file SQL
```bash
mysql -u root -p < database_schema.sql
```

Hoặc trong MySQL Workbench:
```sql
source /path/to/database_schema.sql
```

### Bước 2: Kiểm tra database đã tạo
```sql
USE ptit_learning;
SHOW TABLES;
```

Kết quả sẽ hiển thị 7 bảng:
- `users`
- `courses`
- `cart`
- `orders`
- `order_items`
- `course_progress`
- `user_courses` (nếu có)

---

## 📊 Cấu trúc Database

### 1. Bảng `users`
Lưu thông tin tài khoản người dùng

| Column | Type | Description |
|--------|------|-------------|
| user_id | INT | Primary key |
| email | VARCHAR(255) | Email (unique) |
| phone | VARCHAR(20) | Số điện thoại (unique) |
| password_hash | VARCHAR(255) | Mật khẩu đã hash (SHA-256) |
| fullname | VARCHAR(255) | Họ tên |
| created_at | TIMESTAMP | Ngày tạo |
| updated_at | TIMESTAMP | Ngày cập nhật |

### 2. Bảng `courses`
Lưu thông tin khóa học

| Column | Type | Description |
|--------|------|-------------|
| course_id | VARCHAR(50) | Primary key |
| course_name | VARCHAR(255) | Tên khóa học |
| category | VARCHAR(50) | Danh mục |
| description | TEXT | Mô tả |
| price | DECIMAL(10,2) | Giá |
| old_price | DECIMAL(10,2) | Giá cũ |
| duration | VARCHAR(50) | Thời lượng |
| students_count | INT | Số học viên |
| level | VARCHAR(20) | Cấp độ |
| is_new | TINYINT(1) | Khóa mới |
| discount_percentage | INT | % giảm giá |

**Danh mục:**
- `python` - Lập trình Python
- `finance` - Tài chính
- `data` - Data Analysis
- `blockchain` - Blockchain
- `accounting` - Kế toán
- `marketing` - Marketing

### 3. Bảng `cart`
Lưu giỏ hàng

| Column | Type | Description |
|--------|------|-------------|
| cart_id | INT | Primary key |
| user_id | INT | FK → users |
| course_id | VARCHAR(50) | FK → courses |
| added_at | TIMESTAMP | Ngày thêm |

**Constraints:**
- UNIQUE (user_id, course_id) - Không cho phép trùng
- CASCADE DELETE - Xóa khi user/course bị xóa

### 4. Bảng `orders`
Lưu đơn hàng

| Column | Type | Description |
|--------|------|-------------|
| order_id | INT | Primary key |
| user_id | INT | FK → users |
| total_amount | DECIMAL(10,2) | Tổng tiền |
| payment_method | VARCHAR(50) | Phương thức thanh toán |
| status | VARCHAR(20) | Trạng thái (pending/completed) |
| created_at | TIMESTAMP | Ngày tạo |

### 5. Bảng `order_items`
Lưu chi tiết đơn hàng

| Column | Type | Description |
|--------|------|-------------|
| order_item_id | INT | Primary key |
| order_id | INT | FK → orders |
| course_id | VARCHAR(50) | FK → courses |
| price | DECIMAL(10,2) | Giá |

### 6. Bảng `course_progress`
Lưu tiến độ học tập

| Column | Type | Description |
|--------|------|-------------|
| progress_id | INT | Primary key |
| user_id | INT | FK → users |
| course_id | VARCHAR(50) | FK → courses |
| progress_percentage | INT | % tiến độ (0-100) |
| total_hours | DECIMAL(5,2) | Tổng giờ học |
| last_accessed | TIMESTAMP | Lần truy cập cuối |
| status | VARCHAR(20) | Trạng thái (in_progress/completed) |

**Constraints:**
- UNIQUE (user_id, course_id) - Mỗi user chỉ có 1 progress cho 1 course

---

## 📥 Import Database

### Cách 1: Command Line
```bash
# Windows
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p123456789 < database_schema.sql

# Linux/Mac
mysql -u root -p < database_schema.sql
```

### Cách 2: MySQL Workbench
1. Mở MySQL Workbench
2. File → Run SQL Script
3. Chọn file `database_schema.sql`
4. Click "Run"

### Cách 3: phpMyAdmin
1. Mở phpMyAdmin
2. Click "Import"
3. Chọn file `database_schema.sql`
4. Click "Go"

---

## 👤 Tài khoản Test

File SQL đã tạo sẵn 1 tài khoản test:

**Email:** `test@ptit.edu.vn`  
**Mật khẩu:** `123456`  
**Họ tên:** Nguyen Van Test  
**SĐT:** 0123456789

### Tạo tài khoản mới
```sql
-- Mật khẩu 123456 đã hash
INSERT INTO users (email, phone, password_hash, fullname) VALUES
('your_email@example.com', '0987654321', 
'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 
'Your Name');
```

**Lưu ý:** Password hash sử dụng SHA-256
- `123456` → `8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92`

---

## 🎓 Sample Data

File SQL đã tạo sẵn **18 khóa học** gồm:

### Python (6 khóa)
- Python Basics - 999,000₫
- Python Advanced - 1,299,000₫
- Object-Oriented Python - 1,199,000₫
- Python Web Development - 1,499,000₫
- Python for Data Science - 1,399,000₫
- Procedural Python - 1,299,000₫

### Finance (3 khóa)
- Finance Basics - 1,299,000₫
- Investment Strategies - 1,599,000₫
- Personal Finance - 1,199,000₫

### Data Analysis (2 khóa)
- Data Analysis Fundamentals - 1,399,000₫
- Data Visualization - 1,299,000₫

### Blockchain (2 khóa)
- Blockchain Fundamentals - 1,499,000₫
- Smart Contract Development - 1,799,000₫

### Accounting (2 khóa)
- Accounting Basics - 1,199,000₫
- Advanced Accounting - 1,499,000₫

### Marketing (2 khóa)
- Digital Marketing - 1,399,000₫
- Social Media Marketing - 1,299,000₫

---

## 🛠️ Troubleshooting

### Lỗi: "Access denied for user 'root'@'localhost'"
```bash
# Kiểm tra lại mật khẩu root
mysql -u root -p
```

### Lỗi: "Database already exists"
```sql
-- Xóa database cũ và tạo lại
DROP DATABASE IF EXISTS ptit_learning;
CREATE DATABASE ptit_learning;
```

### Lỗi: "Duplicate entry"
File SQL sử dụng `INSERT IGNORE` nên có thể chạy nhiều lần an toàn.

### Kiểm tra dữ liệu đã import
```sql
USE ptit_learning;

-- Kiểm tra số lượng courses
SELECT COUNT(*) FROM courses;  -- Kết quả: 18

-- Kiểm tra user test
SELECT * FROM users WHERE email = 'test@ptit.edu.vn';

-- Kiểm tra courses theo category
SELECT category, COUNT(*) FROM courses GROUP BY category;
```

### Reset toàn bộ database
```sql
DROP DATABASE IF EXISTS ptit_learning;
source /path/to/database_schema.sql
```

---

## 📝 Notes

1. **Foreign Keys:** Tất cả các bảng đều có foreign key constraints để đảm bảo tính toàn vẹn dữ liệu
2. **Indexes:** Đã tạo index cho các cột thường xuyên query (email, phone, category, status)
3. **Character Set:** UTF-8 (utf8mb4_unicode_ci) để hỗ trợ tiếng Việt và emoji
4. **Engine:** InnoDB để hỗ trợ transaction và foreign key
5. **Auto Increment:** Các ID tự động tăng

---

## 🔐 Security Notes

1. **Password Hash:** Sử dụng SHA-256 (trong production nên dùng BCrypt hoặc Argon2)
2. **SQL Injection:** Code đã sử dụng PreparedStatement để tránh SQL injection
3. **Session:** Session timeout được config trong web.xml

---

## 📞 Support

Nếu gặp vấn đề, kiểm tra:
1. MySQL server đang chạy
2. Port 3306 không bị block
3. User root có quyền CREATE DATABASE
4. Character set UTF-8 được hỗ trợ

---

**Created:** November 2025  
**Version:** 1.0  
**Database:** MySQL 8.0+
