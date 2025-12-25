# 📊 HƯỚNG DẪN SỬ DỤNG CHỨC NĂNG XEM DOANH THU CHI TIẾT THEO USER

## 🎯 Tổng quan

Chức năng mới này cho phép **Admin** xem chi tiết doanh thu theo từng người dùng, bao gồm:
- Tổng số tiền mỗi user đã chi tiêu
- Danh sách các khóa học mà user đã mua
- Giá của từng khóa học
- Ngày mua và mã đơn hàng

## 🚀 Cách sử dụng

### Bước 1: Truy cập Admin Dashboard

1. Đăng nhập với tài khoản admin: `admin@ptit.edu.vn`
2. Vào trang **Admin Dashboard**
3. Chuyển đến tab **"📊 Thống kê"**

### Bước 2: Xem chi tiết doanh thu theo user

1. Cuộn xuống phần **"Top 10 khóa học doanh thu cao nhất"**
2. Bạn sẽ thấy nút **"Xem chi tiết doanh thu theo user"** ở góc phải trên
3. Click vào nút này

### Bước 3: Khám phá thông tin chi tiết

Trên trang chi tiết, bạn sẽ thấy:

#### 📈 Thống kê tổng quan (ở trên cùng):
- 💰 **Tổng doanh thu**: Tổng số tiền từ tất cả các đơn hàng đã được duyệt
- 👥 **Tổng số người dùng**: Số lượng user đã mua khóa học
- 📦 **Tổng số đơn hàng**: Tổng số đơn hàng đã được thanh toán

#### 👤 Chi tiết từng user (sắp xếp theo tổng chi tiêu giảm dần):

Mỗi card user hiển thị:
- **Thông tin user**:
  - Họ tên
  - Email
  - Số điện thoại (nếu có)
  
- **Thống kê của user**:
  - 💰 Tổng chi tiêu
  - 📦 Số đơn hàng
  - 📚 Số khóa học đã mua

- **Bảng danh sách khóa học đã mua**:
  - STT
  - Tên khóa học
  - Danh mục (Python, Finance, Data, Marketing, Blockchain, Accounting)
  - Giá đã thanh toán
  - Ngày mua
  - Mã đơn hàng

## 💡 Các tính năng nổi bật

### 1. 🎨 Giao diện đẹp mắt
- Card user với gradient màu tím
- Badge màu sắc theo danh mục khóa học
- Hover effects mượt mà
- Responsive trên mọi thiết bị

### 2. 📊 Sắp xếp thông minh
- User được sắp xếp theo tổng chi tiêu giảm dần
- Dễ dàng xác định "khách hàng VIP"

### 3. 🔍 Thông tin chi tiết
- Xem được từng khóa học user đã mua
- Giá và ngày mua cụ thể
- Mã đơn hàng để tra cứu

### 4. 📱 Responsive Design
- Hiển thị tốt trên desktop, tablet, mobile
- Bảng có thể scroll ngang trên màn hình nhỏ

## 📝 Lưu ý

- ✅ Chỉ hiển thị các đơn hàng đã được **duyệt** (status = 'approved')
- ✅ Nếu chưa có user nào mua khóa học, sẽ hiển thị thông báo "Chưa có dữ liệu"
- ✅ Có nút **"Quay lại Dashboard"** để quay về trang quản trị

## 🎯 Use Cases

### 1. Phân tích khách hàng
- Xác định top khách hàng chi tiêu nhiều nhất
- Hiểu được sở thích của từng user
- Lập chiến lược marketing phù hợp

### 2. Báo cáo doanh thu
- Xuất báo cáo chi tiết cho ban giám đốc
- Phân tích xu hướng mua hàng
- Đánh giá hiệu quả các chương trình khuyến mãi

### 3. Chăm sóc khách hàng
- Nhận diện khách hàng VIP để có chính sách ưu đãi
- Theo dõi lịch sử giao dịch
- Giải quyết khiếu nại nhanh chóng

## 🔧 Thông tin kỹ thuật

### Files được tạo:

1. **UserRevenueServlet.java**
   - Path: `src/main/java/com/example/servlets/UserRevenueServlet.java`
   - Xử lý logic lấy dữ liệu từ database
   - Tính toán thống kê tổng quan

2. **user-revenue-detail.jsp**
   - Path: `src/main/webapp/user-revenue-detail.jsp`
   - Hiển thị giao diện chi tiết doanh thu
   - Responsive design với CSS inline

3. **Sửa đổi admin-dashboard.jsp**
   - Thêm nút "Xem chi tiết doanh thu theo user"
   - Ở phần thống kê top 10 khóa học

### URL:
```
http://localhost:8080/admin/user-revenue
```

### SQL Query chính:
```sql
SELECT 
    u.user_id, 
    u.email, 
    u.fullname, 
    u.phone, 
    COUNT(DISTINCT o.order_id) as order_count, 
    SUM(o.total_amount) as total_spent, 
    MAX(o.created_at) as last_purchase 
FROM users u 
INNER JOIN orders o ON u.user_id = o.user_id 
WHERE o.status = 'approved' 
GROUP BY u.user_id, u.email, u.fullname, u.phone 
ORDER BY total_spent DESC
```

## 🎉 Kết luận

Chức năng mới này giúp Admin có cái nhìn toàn diện về doanh thu từng user, từ đó đưa ra các quyết định kinh doanh chính xác hơn. Giao diện đẹp mắt, dễ sử dụng và đầy đủ thông tin cần thiết!

---

**Chúc bạn sử dụng hiệu quả! 🚀**
