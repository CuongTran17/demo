# HƯỚNG DẪN SỬ DỤNG CHỨC NĂNG KHÓA TÀI KHOẢN

## 📋 Tổng quan

Hệ thống đã được bổ sung chức năng quản lý khóa tài khoản với các quyền hạn phân cấp:
- **Admin**: Khóa/mở khóa tài khoản trực tiếp (không cần duyệt)
- **Giáo viên**: Yêu cầu khóa tài khoản học viên (cần admin duyệt)
- **Tài khoản bị khóa**: Hiển thị thông báo khi đăng nhập

## 🔧 CÀI ĐẶT

### Bước 1: Cập nhật Database

Chạy file SQL sau để thêm các bảng và cột cần thiết:

```bash
mysql -u root -p ptit_learning < 03-add-account-lock-feature.sql
```

Hoặc import trực tiếp trong MySQL:
1. Mở MySQL Workbench hoặc phpMyAdmin
2. Chọn database `ptit_learning`
3. Import file `03-add-account-lock-feature.sql`

### Bước 2: Build lại project

```bash
mvn clean package
```

### Bước 3: Khởi động lại server

```bash
stop-project.bat
start-project.bat
```

## 📖 HƯỚNG DẪN SỬ DỤNG

### 🔐 Dành cho ADMIN

#### 1. Khóa tài khoản trực tiếp

1. Đăng nhập với tài khoản admin: `admin@ptit.edu.vn`
2. Vào tab **"👥 Người dùng"**
3. Tìm tài khoản cần khóa
4. Click nút **"Khóa TK"**
5. Nhập lý do khóa tài khoản
6. Click **"Khóa tài khoản"**

✅ Tài khoản sẽ bị khóa ngay lập tức, không cần duyệt

#### 2. Mở khóa tài khoản

1. Vào tab **"👥 Người dùng"**
2. Tìm tài khoản đã bị khóa (có biểu tượng 🔒)
3. Click nút **"Mở khóa"**
4. Xác nhận

#### 3. Duyệt yêu cầu khóa tài khoản từ giáo viên

1. Vào tab **"🔒 Yêu cầu khóa TK"**
2. Xem danh sách yêu cầu chờ duyệt
3. Click nút **"Duyệt"** để xem chi tiết
4. Nhập ghi chú (tùy chọn)
5. Click:
   - **"✓ Duyệt"**: Chấp nhận yêu cầu và khóa tài khoản
   - **"❌ Từ chối"**: Từ chối yêu cầu

### 👨‍🏫 Dành cho GIÁO VIÊN

#### 1. Yêu cầu khóa tài khoản học viên

1. Đăng nhập với tài khoản giáo viên (VD: `teacher1@ptit.edu.vn`)
2. Vào tab **"👥 Quản lý học viên"**
3. Tìm học viên cần khóa
4. Click nút **"🔒 Yêu cầu khóa"**
5. Nhập lý do yêu cầu khóa tài khoản
6. Click **"Gửi yêu cầu"**

⏳ Yêu cầu sẽ được gửi đến admin để duyệt

#### 2. Xem trạng thái yêu cầu của mình

1. Vào tab **"👥 Quản lý học viên"**
2. Click nút **"📋 Xem yêu cầu khóa TK"**
3. Xem danh sách các yêu cầu với trạng thái:
   - **⏳ Chờ duyệt**: Đang chờ admin xử lý
   - **✓ Đã duyệt**: Admin đã chấp nhận và khóa tài khoản
   - **❌ Từ chối**: Admin đã từ chối yêu cầu (xem ghi chú để biết lý do)

### 👤 Dành cho NGƯỜI DÙNG

Khi tài khoản bị khóa:
1. Đăng nhập sẽ hiển thị thông báo màu đỏ: 
   > 🔒 **Tài khoản bị khóa**
   > 
   > Tài khoản bị khóa, vui lòng liên hệ admin để được hỗ trợ.

2. Liên hệ admin để biết lý do và yêu cầu mở khóa

## 📊 CẤU TRÚC DATABASE

### Bảng `users` (đã cập nhật)
- `is_locked` (BOOLEAN): Trạng thái khóa tài khoản
- `locked_reason` (TEXT): Lý do khóa
- `locked_by` (INT): ID người thực hiện khóa
- `locked_at` (TIMESTAMP): Thời gian khóa

### Bảng `account_lock_requests` (mới)
- `request_id`: ID yêu cầu
- `target_user_id`: ID tài khoản cần khóa
- `requester_id`: ID giáo viên yêu cầu
- `reason`: Lý do yêu cầu
- `request_type`: Loại yêu cầu (lock/unlock)
- `status`: Trạng thái (pending/approved/rejected)
- `created_at`: Thời gian tạo yêu cầu
- `reviewed_by`: ID admin duyệt
- `reviewed_at`: Thời gian duyệt
- `review_note`: Ghi chú của admin

### View `account_lock_requests_view`
Hiển thị chi tiết yêu cầu khóa tài khoản với thông tin đầy đủ

## 🔒 PHÂN QUYỀN

| Hành động | Admin | Giáo viên | Học viên |
|-----------|-------|-----------|----------|
| Khóa tài khoản trực tiếp | ✅ | ❌ | ❌ |
| Mở khóa tài khoản | ✅ | ❌ | ❌ |
| Yêu cầu khóa học viên | ✅ | ✅ | ❌ |
| Duyệt yêu cầu | ✅ | ❌ | ❌ |
| Xem yêu cầu của mình | - | ✅ | - |

## 📝 GHI CHÚ

1. **Admin không cần duyệt**: Admin có thể khóa/mở khóa bất kỳ tài khoản nào ngay lập tức
2. **Giáo viên cần duyệt**: Yêu cầu từ giáo viên phải được admin duyệt trước khi tài khoản bị khóa
3. **Tài khoản admin không thể bị khóa**: Hệ thống tự động bảo vệ tài khoản admin
4. **Thông báo rõ ràng**: Khi tài khoản bị khóa, người dùng sẽ thấy thông báo chi tiết
5. **Lịch sử đầy đủ**: Hệ thống lưu trữ đầy đủ lịch sử khóa tài khoản và yêu cầu

## 🧪 KIỂM TRA

### Test case 1: Admin khóa tài khoản
1. Đăng nhập admin
2. Khóa tài khoản `user1@ptit.edu.vn`
3. Đăng xuất
4. Đăng nhập với `user1@ptit.edu.vn` → Thấy thông báo khóa ✅

### Test case 2: Giáo viên yêu cầu khóa
1. Đăng nhập teacher1@ptit.edu.vn
2. Yêu cầu khóa một học viên
3. Đăng nhập admin
4. Vào tab "Yêu cầu khóa TK" → Thấy yêu cầu ✅
5. Duyệt yêu cầu
6. Đăng nhập với tài khoản học viên đó → Thấy thông báo khóa ✅

### Test case 3: Mở khóa tài khoản
1. Đăng nhập admin
2. Mở khóa tài khoản đã khóa
3. Đăng nhập với tài khoản đó → Đăng nhập thành công ✅

## 🆘 TROUBLESHOOTING

### Lỗi: "Table 'users' doesn't have column 'is_locked'"
→ Chạy lại file SQL: `03-add-account-lock-feature.sql`

### Lỗi: "404 Not Found" khi truy cập /account-lock
→ Build lại project: `mvn clean package`

### Không thấy tab "Yêu cầu khóa TK" trong admin
→ Xóa cache trình duyệt và refresh lại trang (Ctrl + F5)

### Yêu cầu không hiển thị
→ Kiểm tra console browser (F12) để xem lỗi API

## 📞 HỖ TRỢ

Nếu gặp vấn đề, vui lòng:
1. Kiểm tra console log của server
2. Kiểm tra console log của browser (F12)
3. Kiểm tra database đã cập nhật đúng schema chưa

---

**Phiên bản**: 1.0  
**Ngày cập nhật**: 2025-01-18
