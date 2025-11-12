package com.example.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.example.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/test-db")
public class TestDBServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Database Connection Test</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; padding: 20px; background: #f5f5f5; }");
        out.println(".container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }");
        out.println(".success { color: #28a745; }");
        out.println(".error { color: #dc3545; }");
        out.println("table { width: 100%; border-collapse: collapse; margin-top: 20px; }");
        out.println("th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }");
        out.println("th { background: #007bff; color: white; }");
        out.println(".info { background: #e7f3ff; padding: 15px; border-radius: 5px; margin: 15px 0; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='container'>");
        
        try {
            // Test connection
            Connection conn = DatabaseConnection.getNewConnection();
            
            out.println("<h1 class='success'>✓ Kết nối Database thành công!</h1>");
            
            // Get database metadata
            DatabaseMetaData metaData = conn.getMetaData();
            
            out.println("<div class='info'>");
            out.println("<h3>Thông tin Database:</h3>");
            out.println("<p><strong>Database:</strong> " + metaData.getDatabaseProductName() + "</p>");
            out.println("<p><strong>Version:</strong> " + metaData.getDatabaseProductVersion() + "</p>");
            out.println("<p><strong>Driver:</strong> " + metaData.getDriverName() + "</p>");
            out.println("<p><strong>Driver Version:</strong> " + metaData.getDriverVersion() + "</p>");
            out.println("<p><strong>URL:</strong> " + metaData.getURL() + "</p>");
            out.println("<p><strong>User:</strong> " + metaData.getUserName() + "</p>");
            out.println("</div>");
            
            // List all tables
            out.println("<h3>Các bảng trong database:</h3>");
            out.println("<table>");
            out.println("<tr><th>Tên bảng</th><th>Loại</th><th>Ghi chú</th></tr>");
            
            ResultSet tables = metaData.getTables(null, null, "%", new String[]{"TABLE"});
            boolean hasTables = false;
            
            while (tables.next()) {
                hasTables = true;
                String tableName = tables.getString("TABLE_NAME");
                String tableType = tables.getString("TABLE_TYPE");
                String remarks = tables.getString("REMARKS");
                
                out.println("<tr>");
                out.println("<td>" + tableName + "</td>");
                out.println("<td>" + tableType + "</td>");
                out.println("<td>" + (remarks != null ? remarks : "-") + "</td>");
                out.println("</tr>");
            }
            tables.close();
            
            if (!hasTables) {
                out.println("<tr><td colspan='3' style='text-align: center; color: #dc3545;'>");
                out.println("⚠️ Chưa có bảng nào trong database! Hãy chạy file schema.sql");
                out.println("</td></tr>");
            }
            
            out.println("</table>");
            
            // Check specific tables
            out.println("<div class='info'>");
            out.println("<h3>Kiểm tra các bảng cần thiết:</h3>");
            String[] requiredTables = {"users", "courses", "orders", "order_items", "user_courses"};
            
            for (String tableName : requiredTables) {
                ResultSet rs = metaData.getTables(null, null, tableName, new String[]{"TABLE"});
                if (rs.next()) {
                    out.println("<p>✓ Bảng <strong>" + tableName + "</strong> đã tồn tại</p>");
                } else {
                    out.println("<p class='error'>✗ Bảng <strong>" + tableName + "</strong> chưa được tạo</p>");
                }
                rs.close();
            }
            out.println("</div>");
            
            conn.close();
            
            out.println("<div style='margin-top: 20px; padding: 15px; background: #d4edda; border-radius: 5px;'>");
            out.println("<p><strong>✓ Kết nối hoạt động tốt!</strong></p>");
            out.println("<p>Bạn có thể tiếp tục phát triển ứng dụng.</p>");
            out.println("</div>");
            
        } catch (SQLException e) {
            out.println("<h1 class='error'>✗ Kết nối Database thất bại!</h1>");
            
            out.println("<div class='info' style='background: #f8d7da; border-color: #dc3545;'>");
            out.println("<h3>Thông tin lỗi:</h3>");
            out.println("<p><strong>Lỗi:</strong> " + e.getMessage() + "</p>");
            out.println("<p><strong>SQL State:</strong> " + e.getSQLState() + "</p>");
            out.println("<p><strong>Error Code:</strong> " + e.getErrorCode() + "</p>");
            out.println("</div>");
            
            out.println("<div class='info'>");
            out.println("<h3>Các bước khắc phục:</h3>");
            out.println("<ol>");
            out.println("<li>Kiểm tra MySQL Server đã được khởi động chưa</li>");
            out.println("<li>Kiểm tra username/password trong <code>DatabaseConnection.java</code></li>");
            out.println("<li>Kiểm tra database <strong>ptit_learning</strong> đã được tạo chưa</li>");
            out.println("<li>Chạy file <code>database/schema.sql</code> để tạo database</li>");
            out.println("</ol>");
            out.println("</div>");
            
            out.println("<h3>Stack trace:</h3>");
            out.println("<pre style='background: #f5f5f5; padding: 15px; border-radius: 5px; overflow-x: auto;'>");
            e.printStackTrace(out);
            out.println("</pre>");
        }
        
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
}
