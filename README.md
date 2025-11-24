# 🎓 PTIT LEARNING - E-Learning Platform

A comprehensive online learning platform built with Java EE, featuring course catalog, shopping cart, VietQR payment integration, admin approval system, and multi-role user management.

![Version](https://img.shields.io/badge/version-1.0-blue)
![Java](https://img.shields.io/badge/Java-21-orange)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Tomcat](https://img.shields.io/badge/Tomcat-10.1.48-yellow)
![License](https://img.shields.io/badge/license-MIT-green)

## 📋 Features

### 🔐 Authentication & Security
- User registration with email/phone validation
- Secure login with SHA-256 password hashing
- Role-based access control (Student, Teacher, Admin)
- Remember Me functionality
- Session management
- Password change & forgot password
- Profile management

### 💳 Payment System
- VietQR payment integration with TPBank
- QR code generation for bank transfer
- Admin payment approval workflow
- Order tracking with status updates
- Payment notes and verification

### 🛒 Shopping Experience
- Browse 36+ courses across 6 categories
- Add to cart from any page
- Persistent cart (MySQL database)
- Real-time cart updates
- Secure checkout with payment confirmation
- Course ownership verification

### 👨‍🏫 Teacher Dashboard
- Manage assigned courses
- View student enrollment
- Submit course changes for approval
- Track course statistics
- Pending changes review

### 👨‍💼 Admin Dashboard
- User management (Students & Teachers)
- Course assignment to teachers
- Payment approval system
- Pending changes approval
- System statistics
- User role management

### 🎯 Student Dashboard
- View purchased courses
- Track learning progress with video playback
- Course completion tracking
- Statistics dashboard
- Update personal information
- Order history

### 📺 Learning Experience
- Video-based lessons with YouTube integration
- Progress tracking per lesson
- Section-based course structure
- Mark lessons as completed
- Resume from last position
- Q&A section for each lesson

### 🔍 Search & Filter
- Keyword search across all courses
- Category filtering (6 categories)
- Price range filtering
- Sort by newest/price/popularity
- Beautiful, responsive UI

### 📱 Responsive Design
- Mobile-first approach
- Hamburger menu for mobile
- Touch-friendly interface
- Horizontal scroll for combo cards
- Optimized tables for mobile viewing
- Adaptive layouts for all screen sizes

## 🚀 Quick Start

### Prerequisites
- JDK 21+ (Tested with Java 21)
- Apache Tomcat 10.1.48
- MySQL 8.0+
- Maven 3.9+

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/CuongTran17/demo.git
cd demo
```

2. **Setup database**
```bash
# Import complete database with schema and data
mysql -u root -p < database_complete.sql

# OR import schema only and add sample data separately
mysql -u root -p < database_schema.sql
mysql -u root -p ptit_learning < insert-sample-data.sql
```

3. **Configure database connection**

Edit `src/main/java/com/example/util/DatabaseConnection.java`:
```java
private static final String URL = "jdbc:mysql://localhost:3306/ptit_learning?useUnicode=true&characterEncoding=UTF-8";
private static final String USER = "root";
private static final String PASSWORD = "your_password";
```

4. **Build and run**

**Option 1: Using batch files (Windows)**
```bash
# Build and start everything (recommended)
start-project.bat

# Or start Tomcat only (if already built)
start-tomcat.bat

# Stop Tomcat
stop-project.bat
```

**Option 2: Manual Maven build**
```bash
mvn clean package -DskipTests
# Copy target/ROOT.war to Tomcat webapps
# Start Tomcat
```

5. **Access the application**
```
http://localhost:8080/
```

### Default Accounts
- **Student:** test@ptit.edu.vn / 123456
- **Teacher:** teacher@ptit.edu.vn / 123456
- **Admin:** admin@ptit.edu.vn / 123456

## 📁 Project Structure

```
demo/
├── src/
│   ├── main/
│   │   ├── java/com/example/
│   │   │   ├── dao/              # Database access layer
│   │   │   │   ├── CartDAO.java
│   │   │   │   ├── CourseDAO.java
│   │   │   │   ├── LessonDAO.java
│   │   │   │   ├── OrderDAO.java
│   │   │   │   ├── PendingChangeDAO.java
│   │   │   │   └── UserDAO.java
│   │   │   ├── filters/          # Servlet filters
│   │   │   │   ├── AdminAccessFilter.java
│   │   │   │   ├── EncodingFilter.java
│   │   │   │   ├── LoggingFilter.java
│   │   │   │   └── TeacherAccessFilter.java
│   │   │   ├── model/            # Data models
│   │   │   │   ├── Course.java
│   │   │   │   ├── Lesson.java
│   │   │   │   ├── PendingChange.java
│   │   │   │   └── User.java
│   │   │   ├── servlets/         # Controllers
│   │   │   │   ├── AccountServlet.java
│   │   │   │   ├── AdminServlet.java
│   │   │   │   ├── CartServlet.java
│   │   │   │   ├── CheckoutServlet.java
│   │   │   │   ├── CourseServlet.java
│   │   │   │   ├── LessonServlet.java
│   │   │   │   ├── LoginServlet.java
│   │   │   │   ├── RegisterServlet.java
│   │   │   │   ├── TeacherServlet.java
│   │   │   │   └── ...
│   │   │   └── util/             # Utilities
│   │   │       ├── DatabaseConnection.java
│   │   │       └── PasswordUtil.java
│   │   ├── resources/
│   │   │   └── logback.xml       # Logging config
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       │   └── web.xml       # Web app config
│   │       ├── assets/
│   │       │   ├── css/          # Stylesheets
│   │       │   ├── js/           # JavaScript
│   │       │   └── img/          # Images
│   │       ├── includes/
│   │       │   ├── header.jsp
│   │       │   └── footer.jsp
│   │       ├── account.jsp
│   │       ├── admin-dashboard.jsp
│   │       ├── cart.jsp
│   │       ├── checkout.jsp
│   │       ├── index.jsp
│   │       ├── learning.jsp
│   │       ├── login.jsp
│   │       ├── search.jsp
│   │       ├── signup.jsp
│   │       ├── teacher-dashboard.jsp
│   │       └── courses-*.jsp     # Category pages
│   └── test/                     # Unit tests
├── scripts_archive/              # Archived setup scripts
├── sql_archive/                  # Archived SQL files
├── database_complete.sql         # Full database
├── database_schema.sql           # Schema only
├── insert-sample-data.sql        # Sample data
├── start-project.bat             # Build & run
├── start-tomcat.bat              # Start server
├── stop-project.bat              # Stop server
├── pom.xml                       # Maven config
└── README.md                     # This file
```

## 🗄️ Database Schema

The application uses 11 tables:

- **users** - User accounts with role-based access (student/teacher/admin)
- **courses** - Course catalog (36+ courses)
- **cart** - Shopping cart items (persistent storage)
- **orders** - Order headers with payment status
- **order_items** - Order line items
- **lessons** - Video lessons for each course
- **user_progress** - Learning progress tracking
- **user_courses** - Course ownership mapping
- **teacher_courses** - Teacher-course assignments
- **pending_changes** - Approval workflow for teacher actions
- **categories** - Course categories

### Key Features
- UTF-8 encoding for Vietnamese support
- Foreign key constraints for data integrity
- Indexes for performance optimization
- TIMESTAMP columns for audit trails
- Approval workflow tables for admin control

## 📊 Course Categories

1. **Lập trình - CNTT** (Python courses) - From basics to advanced
2. **Tài chính** (Finance) - Investment, personal finance, forex
3. **Data Analyst** - Data analysis fundamentals, visualization
4. **Blockchain** - Smart contracts, DeFi, NFT
5. **Kế toán** (Accounting) - Basic to advanced, tax
6. **Marketing** - Digital marketing, social media, ads

Total: 36+ courses across all categories

## 🎨 Technologies Used

### Backend
- **Java 21** - Programming language
- **Jakarta EE 10** - Enterprise framework (Servlets, JSP)
- **Apache Tomcat 10.1.48** - Servlet container
- **MySQL 8.0** - Database with UTF8MB4 encoding
- **Maven 3.9.8** - Build tool and dependency management
- **JDBC** - Database connectivity
- **Logback** - Logging framework

### Frontend
- **JSP & JSTL** - Server-side rendering
- **HTML5 & CSS3** - Modern web standards
- **JavaScript (ES6+)** - Client-side logic
- **AJAX & Fetch API** - Asynchronous requests
- **Responsive Design** - Mobile-first approach
- **YouTube IFrame API** - Video integration

### Security
- **SHA-256** - Password hashing with salt
- **PreparedStatement** - SQL injection prevention
- **Session Management** - Secure authentication
- **Role-based Access Control** - Multi-tier permissions
- **Foreign Key Constraints** - Data integrity
- **HTTPS Ready** - Secure communication support

### Payment Integration
- **VietQR API** - QR code generation
- **TPBank** - Banking partner
- **Admin Approval** - Payment verification workflow

## 🔧 Configuration

### Database Connection
Location: `src/main/java/com/example/util/DatabaseConnection.java`

```java
private static final String URL = "jdbc:mysql://localhost:3306/ptit_learning?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh";
private static final String USER = "root";
private static final String PASSWORD = "your_password";
```

### Encoding Filter
Location: `src/main/webapp/WEB-INF/web.xml`

```xml
<filter>
    <filter-name>encodingFilter</filter-name>
    <filter-class>com.example.filters.EncodingFilter</filter-class>
    <init-param>
        <param-name>encoding</param-name>
        <param-value>UTF-8</param-value>
    </init-param>
</filter>
```

### Access Control Filters
- **AdminAccessFilter** - Restricts admin dashboard to admin@ptit.edu.vn
- **TeacherAccessFilter** - Allows teachers and admins to access teacher features

## 🧪 Testing

### Test Accounts
1. **Student Account**
   - Email: test@ptit.edu.vn
   - Password: 123456
   - Features: Browse, purchase, learn courses

2. **Teacher Account**
   - Email: teacher@ptit.edu.vn
   - Password: 123456
   - Features: Manage courses, view students, submit changes

3. **Admin Account**
   - Email: admin@ptit.edu.vn
   - Password: 123456
   - Features: Full system control, approvals, user management

### Testing Workflow
1. **Student Flow**
   - Register/Login
   - Browse courses
   - Add to cart
   - Checkout with VietQR payment
   - Upload payment proof
   - Access courses after admin approval
   - Track learning progress

2. **Teacher Flow**
   - Login as teacher
   - View assigned courses
   - View enrolled students
   - Submit course changes (requires admin approval)
   - Track course statistics

3. **Admin Flow**
   - Login as admin
   - Approve/reject payment confirmations
   - Approve/reject teacher changes
   - Assign courses to teachers
   - Manage users and system

### Payment Testing
- Use VietQR generator for test payments
- Upload any image as payment proof
- Admin can approve/reject from dashboard

## 📚 Documentation

This README covers the complete project. Additional archived documentation:
- Setup scripts in `scripts_archive/`
- Old SQL migrations in `sql_archive/`

## ✨ Highlights

### Modern Features
- ✅ VietQR payment integration
- ✅ Multi-role user system (Student/Teacher/Admin)
- ✅ Approval workflow for sensitive actions
- ✅ Video-based learning with progress tracking
- ✅ Responsive mobile design
- ✅ Vietnamese language support (UTF-8)
- ✅ Real-time cart updates
- ✅ Search and advanced filtering

### Code Quality
- ✅ MVC architecture pattern
- ✅ DAO pattern for data access
- ✅ Prepared statements (SQL injection prevention)
- ✅ Password hashing (SHA-256)
- ✅ Session management
- ✅ Error handling and logging
- ✅ Foreign key constraints

## 🐛 Known Limitations

- Payment is manual (requires admin approval)
- No automated email notifications
- Course videos are YouTube embeds only
- No real-time chat/messaging
- Certificate generation not implemented

## 🚧 Future Enhancements

### Short-term (v1.1)
- [ ] Automated email notifications
- [ ] Payment gateway automation
- [ ] Course reviews and ratings
- [ ] Discussion forums
- [ ] Certificate generation

### Long-term (v2.0)
- [ ] AI-powered recommendations
- [ ] Live streaming classes
- [ ] Mobile application
- [ ] Gamification system
- [ ] Advanced analytics

## 👥 Authors

- **FIN1 Team** - Development Team - PTIT University

## 🙏 Acknowledgments

- PTIT University for project guidance
- Course instructors for technical support
- VietQR API for payment integration
- Open source community for tools and libraries

## 📞 Support

- **Email:** support@ptitlearning.com
- **Website:** http://localhost:8080/
- **Contact Page:** http://localhost:8080/contact.jsp

## 🔮 Roadmap

### Version 1.1 (In Development)
- [x] VietQR payment integration
- [x] Admin approval system
- [x] Teacher dashboard
- [x] Video learning with progress
- [x] Mobile responsive design
- [ ] Email notifications
- [ ] Automated payment verification

### Version 1.2 (Planned)
- [ ] Payment gateway API
- [ ] Course reviews and ratings
- [ ] Discussion forums
- [ ] Certificate generation
- [ ] Live chat support

### Version 2.0 (Future)
- [ ] AI-powered course recommendations
- [ ] Live streaming classes
- [ ] Mobile app (iOS/Android)
- [ ] Gamification system
- [ ] Advanced analytics dashboard

---

**Built with ❤️ by FIN1 Team @ PTIT University**

**© 2025 PTIT LEARNING. All rights reserved.**
