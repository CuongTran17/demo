# ⚠️ CẢNH BÁO VỀ MẤT DỮ LIỆU DATABASE

## Nguyên nhân data bị mất

Database **KHÔNG TỰ ĐỘNG MẤT** khi restart Tomcat server. Dữ liệu chỉ bị xóa khi:

1. **Chạy DatabaseSeeder.java** 
   - File: `src/main/java/com/example/util/DatabaseSeeder.java`
   - Script này **XÓA TOÀN BỘ** dữ liệu và tạo lại courses
   - **KHÔNG BAO GIỜ CHẠY** trừ khi muốn reset hoàn toàn

2. **Chạy setup-database.ps1 và chọn "yes" để DROP database**
   - Script sẽ hỏi: "Do you want to DROP and recreate it? (yes/no)"
   - Chọn "no" để giữ nguyên data hiện tại

3. **Chạy các SQL script có TRUNCATE/DROP**
   - `reset-user-data.sql` - XÓA toàn bộ user data
   - `clean-database-duplicates.sql` - Có thể xóa data
   - **KIỂM TRA KỸ** trước khi chạy

## Cách bảo vệ dữ liệu

### 1. BACKUP THƯỜNG XUYÊN

```powershell
# Backup database (chạy TRƯỚC KHI restart server)
.\backup-database.ps1
```

Backup được lưu trong `backups/` folder với timestamp.

### 2. RESTORE KHI CẦN

```powershell
# Restore từ backup
.\restore-database.ps1 -BackupFile "backups\ptit_learning_backup_2025-11-19_21-00-00.sql"
```

### 3. QUY TẮC AN TOÀN

✅ **AN TOÀN** - Các thao tác này KHÔNG ảnh hưởng database:
- Build project: `mvn clean package`
- Stop/Start Tomcat
- Deploy WAR file mới
- Sửa code Java/JSP
- Restart máy tính

❌ **NGUY HIỂM** - CẦN CẨN THẬN:
- Chạy DatabaseSeeder.java
- Chạy setup-database.ps1 với "yes"
- Chạy SQL scripts có DELETE/TRUNCATE/DROP
- Sửa database schema trực tiếp

## Lý do data có vẻ "mất" sau restart

Nếu bạn thấy courses/progress "mất" sau khi restart server, có thể do:

1. **Browser cache** - Ctrl+F5 để hard refresh
2. **Session expired** - Login lại
3. **Tomcat chưa deploy xong** - Đợi 30 giây sau khi start
4. **Database connection timeout** - Restart MySQL service

## Kiểm tra database hiện tại

```powershell
# Xem số lượng records hiện tại
& 'C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe' -u root -pNTHair935@ ptit_learning -e "
SELECT 'Users' as Table_Name, COUNT(*) as Records FROM users
UNION ALL SELECT 'Courses', COUNT(*) FROM courses
UNION ALL SELECT 'Orders', COUNT(*) FROM orders
UNION ALL SELECT 'Course Progress', COUNT(*) FROM course_progress
UNION ALL SELECT 'Lesson Progress', COUNT(*) FROM lesson_progress;
"
```

## Tóm lại

- ✅ MySQL LƯU DỮ LIỆU VĨNH VIỄN - không mất khi restart
- ⚠️ Chỉ mất khi BẠN CHẠY SCRIPT XÓA
- 💾 Backup thường xuyên để an toàn
- 🔒 KHÔNG chạy DatabaseSeeder trừ khi muốn reset hoàn toàn
