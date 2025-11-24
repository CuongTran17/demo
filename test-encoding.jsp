<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.example.util.DatabaseConnection" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Test Vietnamese Encoding</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <h1>Test Vietnamese Encoding - Kiểm tra tiếng Việt</h1>
    
    <h2>1. JSP Page Encoding Test</h2>
    <p class="success">✓ Static text: Đây là văn bản tiếng Việt có dấu: àáảãạ ăắằẳẵặ âấầẩẫậ đ êếềểễệ ìíỉĩị ôốồổỗộ ơớờởỡợ ùúủũụ ưứừửữự ỳýỷỹỵ</p>
    
    <h2>2. Database Encoding Test</h2>
    <table>
        <thead>
            <tr>
                <th>Course ID</th>
                <th>Course Name (Tên khóa học)</th>
                <th>Description (Mô tả)</th>
                <th>Category (Danh mục)</th>
            </tr>
        </thead>
        <tbody>
            <%
                try (Connection conn = DatabaseConnection.getNewConnection();
                     Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT course_id, course_name, description, category FROM courses LIMIT 10")) {
                    
                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getString("course_id") %></td>
                <td><%= rs.getString("course_name") %></td>
                <td><%= rs.getString("description") %></td>
                <td><%= rs.getString("category") %></td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='4' class='error'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </tbody>
    </table>
    
    <h2>3. User Data Test</h2>
    <table>
        <thead>
            <tr>
                <th>User ID</th>
                <th>Full Name (Họ tên)</th>
                <th>Email</th>
                <th>Role</th>
            </tr>
        </thead>
        <tbody>
            <%
                try (Connection conn = DatabaseConnection.getNewConnection();
                     Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT user_id, fullname, email, role FROM users LIMIT 10")) {
                    
                    while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("user_id") %></td>
                <td><%= rs.getString("fullname") %></td>
                <td><%= rs.getString("email") %></td>
                <td><%= rs.getString("role") %></td>
            </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='4' class='error'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </tbody>
    </table>
    
    <h2>4. Connection String Check</h2>
    <pre><%= DatabaseConnection.class.getName() %> URL settings</pre>
    
    <p><a href="index.jsp">← Back to Home</a></p>
</body>
</html>
