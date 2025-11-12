# PTIT Learning - Backend Setup Guide

## Cấu trúc Backend đã tạo

### 1. Database Layer
- **schema.sql**: Script tạo database và tables
- **DatabaseConnection.java**: Singleton connection manager

### 2. Model Layer
- **User.java**: User entity
- **Course.java**: Course entity

### 3. DAO Layer (Data Access Object)
- **UserDAO.java**: User CRUD operations
- **CourseDAO.java**: Course CRUD operations

### 4. Servlet Layer
- **LoginServlet.java**: Xử lý đăng nhập (đã cập nhật với DB)
- **RegisterServlet.java**: Xử lý đăng ký
- **LogoutServlet.java**: Xử lý đăng xuất

---

## Hướng dẫn cài đặt

### Bước 1: Cài đặt MySQL
1. Download MySQL 8.0+ từ https://dev.mysql.com/downloads/mysql/
2. Cài đặt và khởi động MySQL Server
3. Ghi nhớ root password

### Bước 2: Tạo Database

#### Cách 1: Sử dụng MySQL Workbench (Khuyến nghị - Dễ nhất)
1. Mở **MySQL Workbench**
2. Kết nối tới MySQL Server (localhost)
3. Click **File** → **Open SQL Script**
4. Chọn file `c:\Users\Lenovo\Downloads\demo\database\schema.sql`
5. Click icon ⚡ **(Execute)** để chạy script
6. Kiểm tra bên trái, database **ptit_learning** đã xuất hiện

#### Cách 2: Sử dụng PowerShell (Nếu MySQL đã thêm vào PATH)
```powershell
# Tìm MySQL installation path
$mysqlPath = "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"

# Kết nối và chạy script
& $mysqlPath -u root -p

# Sau khi nhập password, chạy:
# SOURCE c:/Users/Lenovo/Downloads/demo/database/schema.sql;
# exit;
```

#### Cách 3: Copy-paste thủ công
1. Mở MySQL Workbench
2. Tạo connection tới localhost
3. Mở file `database/schema.sql` bằng notepad
4. Copy toàn bộ nội dung
5. Paste vào MySQL Workbench Query Editor
6. Execute (Ctrl+Shift+Enter)

### Bước 3: Cấu hình Database Connection
Mở file `src/main/java/com/example/util/DatabaseConnection.java` và sửa:

```java
private static final String URL = "jdbc:mysql://localhost:3306/ptit_learning?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
private static final String USERNAME = "root";
private static final String PASSWORD = "YOUR_MYSQL_PASSWORD"; // ⬅️ Thay đổi password ở đây
```

### Bước 4: Build Project
```bash
cd c:\Users\Lenovo\Downloads\demo
mvn clean package
```

### Bước 5: Deploy to Tomcat
```powershell
# Stop Tomcat
$env:CATALINA_HOME="C:\Users\Lenovo\Downloads\apache-tomcat-10.1.48-windows-x64\apache-tomcat-10.1.48"
C:\Users\Lenovo\Downloads\apache-tomcat-10.1.48-windows-x64\apache-tomcat-10.1.48\bin\shutdown.bat

# Clear old deployment
Remove-Item "C:\Users\Lenovo\Downloads\apache-tomcat-10.1.48-windows-x64\apache-tomcat-10.1.48\webapps\demo*" -Recurse -Force

# Copy new WAR
Copy-Item "c:\Users\Lenovo\Downloads\demo\target\demo.war" "C:\Users\Lenovo\Downloads\apache-tomcat-10.1.48-windows-x64\apache-tomcat-10.1.48\webapps\"

# Start Tomcat
C:\Users\Lenovo\Downloads\apache-tomcat-10.1.48-windows-x64\apache-tomcat-10.1.48\bin\startup.bat
```

---

## Kiểm tra kết nối

### Test Database Connection
Tạo file test servlet:

```java
@WebServlet("/test-db")
public class TestDBServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            Connection conn = DatabaseConnection.getNewConnection();
            out.println("<h1>✓ Kết nối database thành công!</h1>");
            out.println("<p>Connection: " + conn + "</p>");
            conn.close();
        } catch (SQLException e) {
            out.println("<h1>✗ Kết nối thất bại!</h1>");
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
    }
}
```

Truy cập: http://localhost:8080/demo/test-db

---

## Tài khoản mẫu

Database đã có sẵn 1 tài khoản admin:

- **Email:** admin@ptit.edu.vn
- **Phone:** 0123456789
- **Password:** admin123

---

## API Endpoints

### Authentication
- `POST /login` - Đăng nhập
- `POST /register` - Đăng ký
- `GET /logout` - Đăng xuất

### Courses (sắp tạo)
- `GET /courses` - Lấy tất cả khóa học
- `GET /courses?category=python` - Lấy khóa học theo category
- `GET /course?id=python-basics` - Lấy chi tiết khóa học

### Cart & Orders (sắp tạo)
- `POST /cart/add` - Thêm vào giỏ hàng
- `GET /cart` - Xem giỏ hàng
- `POST /checkout` - Thanh toán

---

## Database Schema

### users
- user_id (PK)
- email (UNIQUE)
- phone (UNIQUE)
- password_hash
- fullname
- created_at, updated_at

### courses
- course_id (PK)
- course_name
- category
- description
- price, old_price
- duration
- students_count
- level
- is_new, discount_percentage

### orders
- order_id (PK)
- user_id (FK)
- total_amount
- payment_method
- status

### order_items
- order_item_id (PK)
- order_id (FK)
- course_id (FK)
- price

### user_courses
- user_course_id (PK)
- user_id (FK)
- course_id (FK)
- purchased_at
- progress

---

## Tiếp theo cần làm

1. ✅ Setup MySQL database
2. ✅ Tạo models & DAOs
3. ✅ Cập nhật LoginServlet, RegisterServlet
4. ⏳ Tạo CourseServlet để load courses từ DB
5. ⏳ Tạo CartServlet & CheckoutServlet
6. ⏳ Tạo AccountServlet để hiển thị khóa học đã mua
7. ⏳ Cập nhật các JSP files để hiển thị data từ DB

---

## Troubleshooting

### Lỗi: ClassNotFoundException: com.mysql.cj.jdbc.Driver
**Giải pháp:** Maven dependency chưa được download
```bash
mvn clean install -U
```

### Lỗi: Access denied for user 'root'@'localhost'
**Giải pháp:** Kiểm tra lại password trong DatabaseConnection.java

### Lỗi: Unknown database 'ptit_learning'
**Giải pháp:** Chạy lại script schema.sql

---

Cần hỗ trợ thêm? Hỏi tôi bất cứ lúc nào! 🚀
