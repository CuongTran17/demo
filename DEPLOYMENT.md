# PTIT LEARNING - Deployment Guide

## 📋 Prerequisites

### Required Software
1. **JDK 17 or higher** (Tested with Java 24)
2. **Apache Tomcat 10.1+** (Jakarta EE 10)
3. **MySQL 8.0+**
4. **Maven 3.6+**

### Environment Setup
```bash
# Verify installations
java -version
mvn -version
mysql --version
```

---

## 🗄️ Database Setup

### Step 1: Create Database
```bash
# Windows PowerShell
Get-Content database_schema.sql -Raw | &"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p

# Linux/Mac
mysql -u root -p < database_schema.sql
```

### Step 2: Verify Database
```sql
USE ptit_learning;
SHOW TABLES;
SELECT COUNT(*) FROM courses;  -- Should return 18
```

### Step 3 (Optional): Add Sample Data
```bash
# Windows
Get-Content sample_data.sql -Raw | mysql -u root -p ptit_learning

# Linux/Mac
mysql -u root -p ptit_learning < sample_data.sql
```

---

## ⚙️ Application Configuration

### 1. Database Connection
Edit `src/main/java/com/example/util/DatabaseConnection.java`:

```java
private static final String URL = "jdbc:mysql://localhost:3306/ptit_learning?useUnicode=true&characterEncoding=utf8";
private static final String USER = "root";
private static final String PASSWORD = "your_password_here";
```

### 2. Session Timeout (Optional)
Edit `src/main/webapp/WEB-INF/web.xml`:

```xml
<session-config>
    <session-timeout>30</session-timeout> <!-- 30 minutes -->
</session-config>
```

---

## 🏗️ Build Application

### Clean and Build
```bash
cd /path/to/demo
mvn clean package
```

### Expected Output
```
[INFO] BUILD SUCCESS
[INFO] Building war: target/demo.war
```

### Verify WAR File
```bash
ls -lh target/demo.war  # Linux/Mac
dir target\demo.war     # Windows
```

---

## 🚀 Deployment Options

### Option 1: Tomcat Auto-Deploy (Recommended)

**Step 1:** Copy WAR to Tomcat
```bash
# Windows
Copy-Item target\demo.war `
  -Destination "C:\path\to\tomcat\webapps\" `
  -Force

# Linux/Mac
cp target/demo.war /path/to/tomcat/webapps/
```

**Step 2:** Start Tomcat
```bash
# Windows
cd C:\path\to\tomcat\bin
startup.bat

# Linux/Mac
cd /path/to/tomcat/bin
./startup.sh
```

**Step 3:** Verify Deployment
- Wait 10-20 seconds for auto-deploy
- Check: http://localhost:8080/demo/

### Option 2: Tomcat Manager

1. Access Tomcat Manager: http://localhost:8080/manager/html
2. Scroll to "WAR file to deploy"
3. Choose `target/demo.war`
4. Click "Deploy"

### Option 3: Manual Deployment

1. Stop Tomcat
2. Delete old deployment:
   ```bash
   rm -rf /path/to/tomcat/webapps/demo
   rm /path/to/tomcat/webapps/demo.war
   ```
3. Copy new WAR file
4. Start Tomcat

---

## ✅ Post-Deployment Verification

### 1. Check Tomcat Logs
```bash
# Windows
tail -f C:\path\to\tomcat\logs\catalina.out

# Linux/Mac
tail -f /path/to/tomcat/logs/catalina.out
```

### 2. Test URLs

| Page | URL | Expected Result |
|------|-----|-----------------|
| Home | http://localhost:8080/demo/ | Homepage loads |
| Login | http://localhost:8080/demo/login.jsp | Login form |
| Signup | http://localhost:8080/demo/signup.jsp | Registration form |
| Courses | http://localhost:8080/demo/courses-python.jsp | Course list |

### 3. Test Login
- Email: `test@ptit.edu.vn`
- Password: `123456`

### 4. Test Features
- [ ] Login successful
- [ ] Add course to cart
- [ ] View cart (should show added course)
- [ ] Checkout page loads
- [ ] Account page shows stats
- [ ] Search page filters work
- [ ] Logout successful

---

## 🔧 Troubleshooting

### Issue: Port 8080 Already in Use
```bash
# Find process using port 8080
netstat -ano | findstr :8080  # Windows
lsof -i :8080                 # Linux/Mac

# Kill the process
taskkill /PID <pid> /F        # Windows
kill -9 <pid>                 # Linux/Mac
```

### Issue: Database Connection Failed
**Error:** `Communications link failure`

**Solution:**
1. Verify MySQL is running:
   ```bash
   # Windows
   Get-Service MySQL*
   
   # Linux
   sudo systemctl status mysql
   ```
2. Check credentials in `DatabaseConnection.java`
3. Test connection:
   ```bash
   mysql -u root -p -e "SELECT 1;"
   ```

### Issue: 404 Not Found
**Error:** `HTTP Status 404 – Not Found`

**Solution:**
1. Check WAR deployed:
   ```bash
   ls /path/to/tomcat/webapps/demo/
   ```
2. Check context path: Should be `/demo` not `/`
3. Restart Tomcat
4. Check logs for deployment errors

### Issue: 500 Internal Server Error
**Error:** `HTTP Status 500 – Internal Server Error`

**Solution:**
1. Check Tomcat logs:
   ```bash
   tail -100 /path/to/tomcat/logs/catalina.out
   ```
2. Common causes:
   - Database not accessible
   - SQL syntax errors
   - Missing foreign key data
3. Verify database schema matches code

### Issue: Cart Empty After Adding
**Symptoms:** Notification shows "Added to cart" but cart page is empty

**Solution:**
1. Check database connection
2. Verify `cart` table exists:
   ```sql
   SHOW TABLES LIKE 'cart';
   DESCRIBE cart;
   ```
3. Check Tomcat console for SQL errors
4. Clear browser cookies and session

---

## 🔐 Security Checklist

### Production Deployment
- [ ] Change database password from default
- [ ] Update `DatabaseConnection.java` with new password
- [ ] Enable HTTPS (SSL/TLS)
- [ ] Set secure session cookies
- [ ] Configure firewall rules
- [ ] Disable directory listing
- [ ] Remove test accounts
- [ ] Enable SQL query logging
- [ ] Set up database backups
- [ ] Configure log rotation

### web.xml Security
```xml
<security-constraint>
    <web-resource-collection>
        <web-resource-name>Protected Area</web-resource-name>
        <url-pattern>/account/*</url-pattern>
    </web-resource-collection>
    <auth-constraint>
        <role-name>user</role-name>
    </auth-constraint>
</security-constraint>
```

---

## 📊 Performance Tuning

### Database Optimization
```sql
-- Add indexes (already in schema)
CREATE INDEX idx_user_id ON cart(user_id);
CREATE INDEX idx_category ON courses(category);

-- Analyze tables
ANALYZE TABLE users, courses, cart, orders;
```

### Tomcat Tuning
Edit `conf/server.xml`:
```xml
<Connector port="8080" protocol="HTTP/1.1"
           maxThreads="200"
           minSpareThreads="10"
           connectionTimeout="20000"
           redirectPort="8443" />
```

### JVM Options
Edit `bin/setenv.sh` (Linux) or `bin/setenv.bat` (Windows):
```bash
JAVA_OPTS="-Xms512m -Xmx1024m -XX:PermSize=256m -XX:MaxPermSize=512m"
```

---

## 🔄 Update Deployment

### Step 1: Backup
```bash
# Backup database
mysqldump -u root -p ptit_learning > backup_$(date +%Y%m%d).sql

# Backup old WAR
cp /path/to/tomcat/webapps/demo.war demo_backup_$(date +%Y%m%d).war
```

### Step 2: Stop Application
```bash
# Undeploy via Tomcat Manager
# OR stop Tomcat
/path/to/tomcat/bin/shutdown.sh
```

### Step 3: Deploy New Version
```bash
# Build new version
mvn clean package

# Copy new WAR
cp target/demo.war /path/to/tomcat/webapps/
```

### Step 4: Start Application
```bash
/path/to/tomcat/bin/startup.sh
```

### Step 5: Verify
- Check logs for errors
- Test critical features
- Verify database migrations

---

## 📝 Environment Variables (Optional)

### Setup
```bash
# Linux/Mac - Add to ~/.bashrc or ~/.bash_profile
export DB_HOST=localhost
export DB_PORT=3306
export DB_NAME=ptit_learning
export DB_USER=root
export DB_PASSWORD=your_password

# Windows - System Environment Variables
setx DB_HOST "localhost"
setx DB_PORT "3306"
setx DB_NAME "ptit_learning"
setx DB_USER "root"
setx DB_PASSWORD "your_password"
```

### Update Code
```java
String host = System.getenv("DB_HOST");
String port = System.getenv("DB_PORT");
String dbName = System.getenv("DB_NAME");
String url = "jdbc:mysql://" + host + ":" + port + "/" + dbName;
```

---

## 🌐 Domain & DNS (Production)

### 1. Point Domain to Server
```
A Record: ptitlearning.com → [Server IP]
CNAME: www → ptitlearning.com
```

### 2. Update Context Path
Edit `conf/server.xml`:
```xml
<Context path="" docBase="demo" reloadable="false" />
```

### 3. Setup SSL Certificate
```bash
# Using Let's Encrypt (certbot)
sudo certbot --apache -d ptitlearning.com -d www.ptitlearning.com
```

---

## 📞 Support

### Logs Location
- **Tomcat:** `/path/to/tomcat/logs/catalina.out`
- **Application:** Check System.out.println in servlets
- **MySQL:** `/var/log/mysql/error.log`

### Common Commands
```bash
# Check Tomcat status
ps aux | grep tomcat

# Check MySQL status
systemctl status mysql

# Check disk space
df -h

# Check memory usage
free -m
```

---

**Last Updated:** November 4, 2025  
**Tested On:** Windows 11, Ubuntu 22.04  
**Tomcat Version:** 10.1.48  
**MySQL Version:** 8.0
