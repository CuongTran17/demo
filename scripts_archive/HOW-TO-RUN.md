# 🚀 PTIT LEARNING - Hướng Dẫn Chạy Dự Án

## ⚡ Cách Nhanh Nhất (Recommended)

### Chạy dự án:
**Double-click:** `start-project.bat`

Hoặc trong terminal:
```cmd
cd C:\Users\AD\Downloads\demo
start-project.bat
```

### Dừng dự án:
**Double-click:** `stop-project.bat`

---

## 📋 Các Bước Thủ Công

### 1. Build Project
```cmd
cd C:\Users\AD\Downloads\demo
C:\tools\apache-maven-3.9.9\bin\mvn.cmd clean package -DskipTests
```

### 2. Deploy WAR file
```cmd
copy target\ROOT.war C:\tomcat10\webapps\ROOT.war
```

### 3. Start Tomcat
**Chạy trong cửa sổ riêng (xem log):**
```cmd
C:\tomcat10\bin\catalina.bat run
```

**Hoặc chạy nền:**
```cmd
C:\tomcat10\bin\startup.bat
```

### 4. Truy cập ứng dụng
http://localhost:8080/

---

## 🔧 PowerShell Commands

### Build và Deploy (một lệnh):
```powershell
cd C:\Users\AD\Downloads\demo
C:\tools\apache-maven-3.9.9\bin\mvn.cmd clean package -DskipTests
Copy-Item target\ROOT.war C:\tomcat10\webapps\ROOT.war -Force
```

### Start Tomcat:
```powershell
Start-Process -FilePath "C:\tomcat10\bin\catalina.bat" -ArgumentList "run"
```

### Stop Tomcat:
```powershell
Stop-Process -Name java -Force
```

---

## 📍 Đường Dẫn Quan Trọng

| Mục đích | Đường dẫn |
|----------|-----------|
| Dự án | `C:\Users\AD\Downloads\demo` |
| Maven | `C:\tools\apache-maven-3.9.9` |
| Tomcat | `C:\tomcat10` |
| WAR file | `C:\Users\AD\Downloads\demo\target\ROOT.war` |
| Logs | `C:\tomcat10\logs` |

---

## 🌐 URLs

| Page | URL |
|------|-----|
| Trang chủ | http://localhost:8080/ |
| Đăng nhập | http://localhost:8080/login.jsp |
| Đăng ký | http://localhost:8080/signup.jsp |
| Khóa học | http://localhost:8080/courses-python.jsp |
| Giỏ hàng | http://localhost:8080/cart.jsp |

---

## 👤 Tài Khoản Test

```
Email: test@ptit.edu.vn
Mật khẩu: 123456
```

---

## 🔄 Workflow Phát Triển

### Khi sửa code Java:
1. Dừng Tomcat: `stop-project.bat`
2. Sửa code
3. Chạy lại: `start-project.bat`

### Khi sửa JSP/CSS/JS:
1. Sửa file
2. Copy file vào: `C:\tomcat10\webapps\ROOT\`
3. Refresh trình duyệt (hoặc Ctrl+F5)

### Build nhanh không cần restart Tomcat:
```cmd
mvn compile war:exploded
```

---

## 🐛 Troubleshooting

### Port 8080 đã được sử dụng
```powershell
# Tìm process đang dùng port 8080
netstat -ano | findstr :8080

# Kill process (thay PID)
taskkill /F /PID <PID>
```

### Tomcat không start
1. Kiểm tra `JAVA_HOME`: `echo %JAVA_HOME%`
2. Xem log: `C:\tomcat10\logs\catalina.*.log`
3. Thử start thủ công: `C:\tomcat10\bin\catalina.bat run`

### Database lỗi
```powershell
# Test kết nối
& "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -pNTHair935@ -e "USE ptit_learning; SELECT COUNT(*) FROM users;"
```

---

## 📂 Cấu Trúc Quan Trọng

```
demo/
├── start-project.bat       ← Chạy dự án
├── stop-project.bat        ← Dừng dự án
├── pom.xml                 ← Maven config
├── src/
│   └── main/
│       ├── java/           ← Java source code
│       │   └── com/example/
│       │       ├── servlets/
│       │       ├── dao/
│       │       └── util/
│       └── webapp/         ← JSP, CSS, JS
│           ├── *.jsp
│           ├── assets/
│           └── WEB-INF/
└── target/
    └── ROOT.war            ← File deploy
```

---

## ⚙️ Cấu Hình Database

- **File:** `src/main/java/com/example/util/DatabaseConnection.java`
- **Database:** ptit_learning
- **User:** root
- **Password:** NTHair935@

---

## 📝 Notes

- Mỗi lần sửa code Java phải rebuild và redeploy
- JSP có thể sửa trực tiếp trong `webapps/ROOT/` để test nhanh
- Log Tomcat ở `C:\tomcat10\logs\`
- Maven cache ở `C:\Users\AD\.m2\repository\`

---

**Last updated:** November 12, 2025
