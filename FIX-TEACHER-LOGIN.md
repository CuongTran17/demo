# 🔧 FIX LỖI ĐĂNG NHẬP TEACHER

## ❌ VẤN ĐỀ
Hash mật khẩu của các tài khoản teacher trong database **SAI**!

- **Database có hash SAI:** `8a2ea2b02e1478c0e8c802bc380c52e867024690c14c934e6c76c2265c6f3ec6`
- **Hash đúng của "teacher123":** `cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416`

Do đó khi bạn nhập mật khẩu `teacher123`, hệ thống hash ra một giá trị khác và không khớp với database.

## ✅ CÁCH SỬA

### Cách 1: Dùng MySQL Workbench (KHUYẾN NGHỊ)

1. Mở **MySQL Workbench**
2. Connect vào database `ptit_learning`
3. Chạy script sau:

```sql
UPDATE users 
SET password_hash = 'cde383eee8ee7a4400adf7a15f716f179a2eb97646b37e089eb8d6d04e663416' 
WHERE email LIKE 'teacher%@ptit.edu.vn';
```

4. Verify kết quả:

```sql
SELECT email, password_hash, fullname 
FROM users 
WHERE email LIKE 'teacher%@ptit.edu.vn';
```

### Cách 2: Import lại toàn bộ database

Chạy file `database_complete.sql` (đã được fix):

```powershell
# Trong MySQL Workbench: File → Run SQL Script → chọn database_complete.sql
```

## 📋 SAU KHI SỬA

Bạn có thể đăng nhập với:
- **Email:** teacher1@ptit.edu.vn (hoặc teacher2, teacher3, v.v...)
- **Password:** teacher123

## 🔍 TẠI SAO XẢY RA LỖI NÀY?

File SQL ban đầu có hash SAI. Đã sửa trong commit tiếp theo.

Hash được tính bằng SHA-256 trong Java code:
```java
MessageDigest digest = MessageDigest.getInstance("SHA-256");
byte[] hash = digest.digest(password.getBytes());
```

Cần đảm bảo hash trong database khớp với hash mà code Java tạo ra!
