# 🎓 PTIT LEARNING - E-Learning Platform

A full-featured online learning platform built with Java EE, featuring course catalog, shopping cart, checkout system, and user account management.

![Version](https://img.shields.io/badge/version-1.0-blue)
![Java](https://img.shields.io/badge/Java-24-orange)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Tomcat](https://img.shields.io/badge/Tomcat-10.1-yellow)
![License](https://img.shields.io/badge/license-MIT-green)

## 📋 Features

### 🔐 Authentication & Security
- User registration with email/phone validation
- Secure login with SHA-256 password hashing
- Remember Me functionality
- Session management
- Password change
- Profile management

### 🛒 Shopping Experience
- Browse 18 courses across 6 categories
- Add to cart from any page
- Persistent cart (MySQL database)
- Real-time cart updates
- Discount code system
- Secure checkout process

### 🎯 User Dashboard
- View purchased courses
- Track learning progress
- Statistics dashboard
- Update personal information
- Change password

### 🔍 Search & Filter
- Keyword search
- Category filtering (7 categories)
- Price range filtering
- Sort by price/date/popularity
- Beautiful, responsive UI

### 📱 Responsive Design
- Mobile-first approach
- Hamburger menu for mobile
- Touch-friendly interface
- Optimized for all screen sizes

## 🚀 Quick Start

### Prerequisites
- JDK 17+ (Tested with Java 24)
- Apache Tomcat 10.1+
- MySQL 8.0+
- Maven 3.6+

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/ptit-learning.git
cd ptit-learning
```

2. **Setup database**
```bash
# Import database schema
mysql -u root -p < database_schema.sql

# (Optional) Import sample data
mysql -u root -p ptit_learning < sample_data.sql
```

3. **Configure database connection**

Edit `src/main/java/com/example/util/DatabaseConnection.java`:
```java
private static final String URL = "jdbc:mysql://localhost:3306/ptit_learning";
private static final String USER = "root";
private static final String PASSWORD = "your_password";
```

4. **Build the project**
```bash
mvn clean package
```

5. **Deploy to Tomcat**
```bash
# Copy WAR file to Tomcat webapps
cp target/demo.war /path/to/tomcat/webapps/

# Start Tomcat
/path/to/tomcat/bin/startup.sh
```

6. **Access the application**
```
http://localhost:8080/demo/
```

### Test Account
- **Email:** test@ptit.edu.vn
- **Password:** 123456

## 📁 Project Structure

```
ptit-learning/
├── src/
│   ├── main/
│   │   ├── java/com/example/
│   │   │   ├── dao/           # Database access layer
│   │   │   ├── model/         # Data models
│   │   │   ├── servlets/      # Controllers
│   │   │   └── util/          # Utilities
│   │   └── webapp/
│   │       ├── WEB-INF/
│   │       ├── assets/        # CSS, JS, images
│   │       └── *.jsp          # View templates
│   └── test/                  # Unit tests
├── database_schema.sql        # Database setup
├── sample_data.sql           # Sample data
├── pom.xml                   # Maven config
├── DATABASE_README.md        # DB documentation
├── DEPLOYMENT.md            # Deployment guide
└── README.md                # This file
```

## 🗄️ Database Schema

The application uses 7 tables:

- **users** - User accounts
- **courses** - Course catalog (18 courses)
- **cart** - Shopping cart items
- **orders** - Order headers
- **order_items** - Order details
- **course_progress** - Learning progress
- **user_courses** - (Legacy)

See [DATABASE_README.md](DATABASE_README.md) for detailed schema.

## 📊 Course Categories

1. **Python Programming** (6 courses) - From basics to advanced
2. **Finance** (3 courses) - Investment, personal finance
3. **Data Analysis** (2 courses) - Fundamentals, visualization
4. **Blockchain** (2 courses) - Smart contracts, fundamentals
5. **Accounting** (2 courses) - Basic to advanced
6. **Marketing** (2 courses) - Digital, social media

## 🎨 Technologies Used

### Backend
- **Java 24** - Programming language
- **Jakarta EE 10** - Enterprise framework
- **Apache Tomcat 10.1.48** - Servlet container
- **MySQL 8.0** - Database
- **Maven 3.9.8** - Build tool

### Frontend
- **JSP** - View templates
- **HTML5 & CSS3** - Modern web standards
- **JavaScript (ES6+)** - Client-side logic
- **AJAX** - Asynchronous requests
- **Responsive Design** - Mobile-friendly

### Security
- **SHA-256** - Password hashing
- **PreparedStatement** - SQL injection prevention
- **Session Management** - Secure sessions
- **Foreign Keys** - Data integrity

## 🔧 Configuration

### Database Connection
Location: `src/main/java/com/example/util/DatabaseConnection.java`

```java
private static final String URL = "jdbc:mysql://localhost:3306/ptit_learning?useUnicode=true&characterEncoding=utf8";
private static final String USER = "root";
private static final String PASSWORD = "123456789";
```

### Session Timeout
Location: `src/main/webapp/WEB-INF/web.xml`

```xml
<session-config>
    <session-timeout>30</session-timeout>
</session-config>
```

## 🧪 Testing

### Manual Testing
1. Login with test account
2. Browse courses
3. Add to cart
4. Checkout
5. View account dashboard
6. Test search & filters

### Discount Codes
- `PTIT10` - 10% discount
- `PTIT20` - 20% discount
- `SAVE30` - 30% discount

## 📚 Documentation

- [Database Schema](DATABASE_README.md) - Database documentation
- [Deployment Guide](DEPLOYMENT.md) - How to deploy
- [Project Summary](PROJECT_SUMMARY.md) - Technical details

## 🐛 Known Issues

- Checkout doesn't create actual orders (clears cart only)
- Search page uses hardcoded data (should load from database)
- No email integration for forgot password
- Course progress tracking is manual

See [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) for complete TODO list.

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **FIN1 Team** - Initial work - PTIT University

## 🙏 Acknowledgments

- PTIT University for project guidance
- Course instructors for technical support
- Open source community for tools and libraries

## 📞 Support

For support, email: support@ptitlearning.com

Or visit our website: http://localhost:8080/demo/contact.jsp

## 🔮 Roadmap

### Version 1.1 (Planned)
- [ ] Complete order creation system
- [ ] Email notifications
- [ ] Admin dashboard
- [ ] Course reviews and ratings

### Version 1.2 (Planned)
- [ ] Payment gateway integration
- [ ] Video streaming
- [ ] Certificate generation
- [ ] Mobile app

### Version 2.0 (Future)
- [ ] AI-powered course recommendations
- [ ] Live streaming classes
- [ ] Discussion forums
- [ ] Gamification

---

**Built with ❤️ by FIN1 Team**

**© 2025 PTIT LEARNING. All rights reserved.**
