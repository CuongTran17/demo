package com.example.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.example.util.DatabaseConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/fix-encoding")
public class FixEncodingServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><meta charset='UTF-8'><title>Fix Encoding</title></head><body>");
        out.println("<h1>Fixing Course Encoding...</h1>");
        
        try (Connection conn = DatabaseConnection.getNewConnection()) {
            // Fix specific courses with proper Vietnamese names and duration
            fixCourseWithDuration(conn, "google-ads", "Google Ads & SEO Mastery toàn tập", "Quảng cáo Google và SEO hiệu quả", "20 giờ");
            fixCourseWithDuration(conn, "banking", "Ngân hàng hiện đại", "Hoạt động ngân hàng và dịch vụ tài chính hiện đại", "15 giờ");
            fixCourseWithDuration(conn, "blockchain-basic", "Blockchain cơ bản", "Kiến thức nền tảng về công nghệ Blockchain", "14 giờ");
            fixCourseWithDuration(conn, "accounting-basic", "Kế toán cơ bản", "Kiến thức nền tảng về kế toán cho người mới bắt đầu", "12 giờ");
            fixCourseWithDuration(conn, "digital-marketing", "Marketing số", "Digital Marketing toàn diện từ cơ bản đến nâng cao", "16 giờ");
            fixCourseWithDuration(conn, "data-basic", "Data Analytics cơ bản", "Phân tích dữ liệu cơ bản cho người mới bắt đầu", "12 giờ");
            fixCourseWithDuration(conn, "python-excel", "Python Excel cho người đi làm", "Tự động hóa Excel bằng Python", "8 giờ");
            fixCourseWithDuration(conn, "content-marketing", "Content Marketing Strategy", "Chiến lược nội dung hiệu quả", "14 giờ");
            fixCourseWithDuration(conn, "cost-accounting", "Kế toán chi phí sản xuất", "Tính giá thành sản phẩm", "16 giờ");
            fixCourseWithDuration(conn, "crypto-trading", "Crypto Trading Strategy", "Giao dịch tiền mã hóa", "18 giờ");
            fixCourseWithDuration(conn, "defi", "DeFi toàn tập", "Tài chính phi tập trung", "20 giờ");
            fixCourseWithDuration(conn, "email-marketing", "Email Marketing chuyên nghiệp", "Email marketing hiệu quả", "10 giờ");
            fixCourseWithDuration(conn, "excel-accounting", "Excel cho kế toán", "Excel nâng cao cho kế toán", "12 giờ");
            fixCourseWithDuration(conn, "excel-data", "Excel cho Data Analyst", "Excel nâng cao cho phân tích dữ liệu", "10 giờ");
            fixCourseWithDuration(conn, "facebook-ads", "Facebook Ads chuyên sâu", "Quảng cáo Facebook hiệu quả", "14 giờ");
            fixCourseWithDuration(conn, "financial-analysis", "Phân tích báo cáo tài chính", "Đọc và phân tích BCTC doanh nghiệp", "16 giờ");
            fixCourseWithDuration(conn, "financial-statements", "Lập báo cáo tài chính", "Báo cáo tài chính doanh nghiệp", "18 giờ");
            fixCourseWithDuration(conn, "forex", "Trading Forex chuyên nghiệp", "Giao dịch ngoại hối hiệu quả", "18 giờ");
            fixCourseWithDuration(conn, "investment", "Đầu tư chứng khoán từ A-Z", "Phân tích và chiến lược đầu tư", "20 giờ");
            fixCourseWithDuration(conn, "nft", "NFT và Metaverse", "Tạo và giao dịch NFT", "16 giờ");
            fixCourseWithDuration(conn, "personal-finance", "Tài chính cá nhân thông minh", "Quản lý tài chính cá nhân hiệu quả", "12 giờ");
            fixCourseWithDuration(conn, "power-bi", "Power BI toàn tập", "Trực quan hóa dữ liệu với Power BI", "18 giờ");
            fixCourseWithDuration(conn, "python-complete", "Python Toàn Tập - Từ Zero đến Hero", "Khóa học Python toàn diện nhất", "40 giờ");
            fixCourseWithDuration(conn, "selenium-python", "Selenium Python - Test Automation", "Automation testing với Selenium", "18 giờ");
            fixCourseWithDuration(conn, "smart-contract", "Smart Contract với Solidity", "Phát triển smart contract", "24 giờ");
            fixCourseWithDuration(conn, "social-media", "Social Media Marketing", "Marketing trên mạng xã hội", "12 giờ");
            fixCourseWithDuration(conn, "sql-data", "SQL cho Data Analyst", "Truy vấn và phân tích dữ liệu với SQL", "16 giờ");
            fixCourseWithDuration(conn, "tableau", "Tableau Desktop chuyên nghiệp", "Visualization với Tableau", "16 giờ");
            fixCourseWithDuration(conn, "tax-accounting", "Kế toán thuế thực hành", "Khai báo và quyết toán thuế", "14 giờ");
            fixCourseWithDuration(conn, "web3", "Web3 Development", "Phát triển ứng dụng Web3", "28 giờ");
            fixCourseWithDuration(conn, "accounting-misa", "Kế toán trên phần mềm MISA", "Làm chủ phần mềm MISA", "18 giờ");
            
            out.println("<h2>✅ Fixed all course encoding issues!</h2>");
            out.println("<p><a href='/search.jsp'>Go to Search Page</a></p>");
            
        } catch (SQLException e) {
            out.println("<h2>❌ Error: " + e.getMessage() + "</h2>");
        }
        
        out.println("</body></html>");
    }
    
    private void fixCourse(Connection conn, String courseId, String courseName, String description) 
            throws SQLException {
        String sql = "UPDATE courses SET course_name = ?, description = ? WHERE course_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, courseName);
            stmt.setString(2, description);
            stmt.setString(3, courseId);
            stmt.executeUpdate();
        }
    }
    
    private void fixCourseWithDuration(Connection conn, String courseId, String courseName, String description, String duration) 
            throws SQLException {
        String sql = "UPDATE courses SET course_name = ?, description = ?, duration = ? WHERE course_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, courseName);
            stmt.setString(2, description);
            stmt.setString(3, duration);
            stmt.setString(4, courseId);
            stmt.executeUpdate();
        }
    }
}