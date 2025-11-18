# HƯỚNG DẪN FIX LỖI TIẾNG VIỆT - QUAN TRỌNG!

## VẤN ĐỀ:
Data trong database đã bị lỗi encoding từ trước. Dù servlet có set UTF-8 nhưng data đã lưu sai nên vẫn hiển thị lỗi.

## GIẢI PHÁP:
Chạy file SQL `fix-encoding-database.sql` để:
1. Xóa TOÀN BỘ data cũ (orders, cart, progress)
2. Convert table courses sang UTF-8 đúng
3. Insert lại tất cả courses với tiếng Việt chuẩn

## CÁCH CHẠY:

### Cách 1: MySQL Workbench
1. Mở MySQL Workbench
2. Connect vào database `ptit_learning`
3. File -> Open SQL Script -> Chọn `fix-encoding-database.sql`
4. Click Execute (⚡ icon)
5. Chờ script chạy xong

### Cách 2: Command Line
```bash
# Tìm MySQL trong Program Files
cd "C:\Program Files\MySQL\MySQL Server 8.0\bin"

# Chạy script
.\mysql.exe -u root -pNTHair935@ ptit_learning < "C:\Users\AD\Downloads\demo\fix-encoding-database.sql"
```

### Cách 3: phpMyAdmin
1. Vào http://localhost/phpmyadmin
2. Chọn database `ptit_learning`
3. Tab "SQL"
4. Copy toàn bộ nội dung file `fix-encoding-database.sql`
5. Paste vào và click "Go"

## SAU KHI CHẠY XONG:
- ✅ Tất cả khóa học sẽ hiển thị tiếng Việt CHUẨN
- ✅ Tất cả users sẽ như mới (không có khóa học đã mua)
- ✅ Giỏ hàng trống
- ✅ Không có tiến trình học tập cũ

## KIỂM TRA:
Sau khi chạy script, refresh website và kiểm tra:
- Trang giỏ hàng: Tên khóa học phải hiển thị tiếng Việt đúng
- Trang tài khoản: "Tài khoản của tôi" phải hiển thị đúng
- Mua khóa học mới để test

## LƯU Ý:
Script này sẽ XÓA TOÀN BỘ data test cũ. Đây là cần thiết để fix lỗi encoding!
