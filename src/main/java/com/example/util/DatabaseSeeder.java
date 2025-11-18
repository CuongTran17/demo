package com.example.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;

public class DatabaseSeeder {
    
    public static void main(String[] args) {
        try {
            System.out.println("=== BẮT ĐẦU RESET DATABASE ===");
            resetDatabase();
            System.out.println("\n=== HOÀN THÀNH! ===");
            System.out.println("✓ Đã xóa toàn bộ dữ liệu người dùng");
            System.out.println("✓ Đã tạo lại bảng courses với UTF-8");
            System.out.println("✓ Đã thêm 36 khóa học với tiếng Việt chuẩn");
        } catch (Exception e) {
            System.err.println("LỖI: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void resetDatabase() throws Exception {
        try (Connection conn = DatabaseConnection.getNewConnection()) {
            conn.setAutoCommit(false);
            
            try (Statement stmt = conn.createStatement()) {
                // 1. Xóa dữ liệu user
                System.out.println("1. Xóa dữ liệu người dùng...");
                stmt.execute("SET foreign_key_checks = 0");
                stmt.execute("TRUNCATE TABLE course_progress");
                stmt.execute("TRUNCATE TABLE order_items");
                stmt.execute("TRUNCATE TABLE orders");
                stmt.execute("TRUNCATE TABLE cart");
                System.out.println("   ✓ Đã xóa: course_progress, order_items, orders, cart");
                
                // 2. Drop và tạo lại bảng courses
                System.out.println("\n2. Tạo lại bảng courses...");
                stmt.execute("DROP TABLE IF EXISTS courses");
                
                String createTable = "CREATE TABLE courses (" +
                    "course_id VARCHAR(50) PRIMARY KEY," +
                    "course_name VARCHAR(255) NOT NULL," +
                    "category VARCHAR(50) NOT NULL," +
                    "description TEXT," +
                    "price DECIMAL(10,2) NOT NULL," +
                    "old_price DECIMAL(10,2)," +
                    "duration VARCHAR(50)," +
                    "students_count INT DEFAULT 0," +
                    "level VARCHAR(20)," +
                    "thumbnail VARCHAR(255)," +
                    "is_new TINYINT(1) DEFAULT 0," +
                    "discount_percentage INT DEFAULT 0," +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                    "INDEX idx_category (category)" +
                    ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";
                
                stmt.execute(createTable);
                System.out.println("   ✓ Đã tạo bảng courses với UTF-8");
                
                // 3. INSERT courses với tiếng Việt
                System.out.println("\n3. Thêm khóa học...");
                insertCourses(conn);
                
                stmt.execute("SET foreign_key_checks = 1");
                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                throw e;
            }
        }
    }
    
    private static void insertCourses(Connection conn) throws Exception {
        String sql = "INSERT INTO courses (course_id, course_name, category, description, " +
                    "price, old_price, duration, students_count, level, is_new, discount_percentage) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            // PYTHON COURSES
            addCourse(pstmt, "python-procedural", "Procedural Python - Lập trình hàm trong Python", 
                     "python", "Học lập trình hàm trong Python từ cơ bản đến nâng cao", 
                     1299000, 2499000, "12 giờ", 1234, "Beginner", 1, 48);
            
            addCourse(pstmt, "python-basics", "Python Basics - Lập trình Python cơ bản", 
                     "python", "Khóa học Python cho người mới bắt đầu", 
                     999000, 1999000, "10 giờ", 2567, "Beginner", 0, 50);
            
            addCourse(pstmt, "python-complete", "Python Toàn Tập - Từ Zero đến Hero", 
                     "python", "Khóa học Python toàn diện nhất", 
                     2499000, 4999000, "40 giờ", 5678, "All", 0, 50);
            
            addCourse(pstmt, "python-excel", "Python Excel cho người đi làm", 
                     "python", "Tự động hóa Excel bằng Python", 
                     899000, 1799000, "8 giờ", 1890, "Intermediate", 0, 50);
            
            addCourse(pstmt, "selenium-python", "Selenium Python - Test Automation", 
                     "python", "Automation testing với Selenium và Python", 
                     1599000, 2999000, "18 giờ", 987, "Advanced", 0, 47);
            
            addCourse(pstmt, "python-oop", "Python OOP - Lập trình hướng đối tượng", 
                     "python", "Lập trình hướng đối tượng với Python", 
                     1199000, 2399000, "14 giờ", 756, "Intermediate", 0, 50);
            
            // FINANCE COURSES
            addCourse(pstmt, "finance-basic", "Tài chính cơ bản", 
                     "finance", "Kiến thức nền tảng tài chính cho người mới", 
                     799000, 1599000, "10 giờ", 2345, "Beginner", 1, 50);
            
            addCourse(pstmt, "investment", "Đầu tư chứng khoán từ A-Z", 
                     "finance", "Phân tích và chiến lược đầu tư", 
                     1699000, 3099000, "20 giờ", 3890, "Intermediate", 1, 45);
            
            addCourse(pstmt, "banking", "Nghiệp vụ ngân hàng hiện đại", 
                     "finance", "Nghiệp vụ Ngân hàng Thương mại", 
                     1299000, 2599000, "8.5 giờ", 1982, "Intermediate", 0, 50);
            
            addCourse(pstmt, "personal-finance", "Quản lý tài chính cá nhân thông minh", 
                     "finance", "Hành trình Tự do Tài chính", 
                     699000, 1399000, "4.2 giờ", 2812, "Beginner", 1, 50);
            
            addCourse(pstmt, "forex", "Trading Forex cho người mới", 
                     "finance", "Trading Forex toàn diện", 
                     1599000, 2999000, "12 giờ", 2678, "Advanced", 0, 47);
            
            addCourse(pstmt, "financial-analysis", "Phân tích báo cáo tài chính", 
                     "finance", "Phân tích báo cáo tài chính toàn diện", 
                     1499000, 2999000, "7 giờ", 1876, "Intermediate", 0, 50);
            
            // DATA SCIENCE COURSES
            addCourse(pstmt, "data-basic", "Data Science cơ bản", 
                     "data", "Khởi đầu sự nghiệp Data Science", 
                     1199000, 2399000, "15 giờ", 3456, "Beginner", 1, 50);
            
            addCourse(pstmt, "data-analysis", "Phân tích dữ liệu với Python", 
                     "data", "Pandas, NumPy, Matplotlib", 
                     1599000, 2999000, "18 giờ", 2890, "Intermediate", 0, 47);
            
            addCourse(pstmt, "machine-learning", "Machine Learning A-Z", 
                     "data", "Học máy từ cơ bản đến nâng cao", 
                     2499000, 4999000, "35 giờ", 4567, "Advanced", 1, 50);
            
            addCourse(pstmt, "deep-learning", "Deep Learning và Neural Networks", 
                     "data", "TensorFlow và Keras", 
                     2999000, 5999000, "40 giờ", 1987, "Advanced", 0, 50);
            
            addCourse(pstmt, "data-visualization", "Trực quan hóa dữ liệu chuyên nghiệp", 
                     "data", "Power BI và Tableau", 
                     999000, 1999000, "12 giờ", 2345, "Intermediate", 0, 50);
            
            addCourse(pstmt, "sql-database", "SQL và Database từ Zero đến Hero", 
                     "data", "MySQL, PostgreSQL, MongoDB", 
                     1299000, 2599000, "16 giờ", 3210, "Intermediate", 0, 50);
            
            // BLOCKCHAIN COURSES
            addCourse(pstmt, "blockchain-basic", "Blockchain cơ bản", 
                     "blockchain", "Công nghệ Blockchain từ A-Z", 
                     1499000, 2999000, "14 giờ", 1678, "Beginner", 1, 50);
            
            addCourse(pstmt, "ethereum", "Lập trình Ethereum và Smart Contracts", 
                     "blockchain", "Solidity và Web3.js", 
                     2499000, 4999000, "25 giờ", 987, "Advanced", 1, 50);
            
            addCourse(pstmt, "nft", "NFT - Tạo và Kinh doanh NFT", 
                     "blockchain", "OpenSea, Rarible, Minting", 
                     1799000, 3599000, "10 giờ", 1234, "Intermediate", 0, 50);
            
            addCourse(pstmt, "defi", "DeFi - Tài chính phi tập trung", 
                     "blockchain", "Uniswap, PancakeSwap, Yield Farming", 
                     1999000, 3999000, "12 giờ", 876, "Advanced", 0, 50);
            
            addCourse(pstmt, "crypto-trading", "Trading Cryptocurrency chuyên nghiệp", 
                     "blockchain", "Technical Analysis, Risk Management", 
                     1599000, 2999000, "15 giờ", 2456, "Intermediate", 0, 47);
            
            addCourse(pstmt, "web3", "Web3 Development - Tương lai của Internet", 
                     "blockchain", "React, Ethers.js, IPFS", 
                     2199000, 4399000, "28 giờ", 654, "Advanced", 1, 50);
            
            // ACCOUNTING COURSES
            addCourse(pstmt, "accounting-basic", "Kế toán cơ bản", 
                     "accounting", "Kế toán cho người mới bắt đầu", 
                     699000, 1399000, "12 giờ", 3987, "Beginner", 1, 50);
            
            addCourse(pstmt, "accounting-intermediate", "Kế toán trung cấp", 
                     "accounting", "Kế toán Doanh nghiệp", 
                     1199000, 2399000, "18 giờ", 2678, "Intermediate", 0, 50);
            
            addCourse(pstmt, "accounting-tax", "Kế toán Thuế", 
                     "accounting", "Thuế GTGT, TNCN, TNDN", 
                     1499000, 2999000, "15 giờ", 1987, "Intermediate", 0, 50);
            
            addCourse(pstmt, "excel-accounting", "Excel cho Kế toán", 
                     "accounting", "Pivot Table, VLookup, Macro", 
                     899000, 1799000, "10 giờ", 3456, "Beginner", 0, 50);
            
            addCourse(pstmt, "misa", "MISA Accounting - Phần mềm Kế toán", 
                     "accounting", "Sử dụng MISA chuyên nghiệp", 
                     999000, 1999000, "8 giờ", 2134, "Intermediate", 0, 50);
            
            addCourse(pstmt, "audit", "Kiểm toán nội bộ và Kiểm soát", 
                     "accounting", "Internal Audit và Risk Management", 
                     1699000, 3399000, "16 giờ", 987, "Advanced", 0, 50);
            
            // MARKETING COURSES
            addCourse(pstmt, "marketing-basic", "Marketing cơ bản", 
                     "marketing", "4P, STP, Marketing Mix", 
                     799000, 1599000, "10 giờ", 4567, "Beginner", 1, 50);
            
            addCourse(pstmt, "digital-marketing", "Digital Marketing toàn diện", 
                     "marketing", "SEO, SEM, Social Media, Content", 
                     1499000, 2999000, "20 giờ", 5678, "Intermediate", 1, 50);
            
            addCourse(pstmt, "facebook-ads", "Facebook Ads A-Z", 
                     "marketing", "Chạy quảng cáo Facebook hiệu quả", 
                     999000, 1999000, "12 giờ", 3890, "Intermediate", 0, 50);
            
            addCourse(pstmt, "google-ads", "Google Ads - Quảng cáo Google", 
                     "marketing", "Search, Display, Shopping, Video", 
                     1299000, 2599000, "14 giờ", 2987, "Intermediate", 0, 50);
            
            addCourse(pstmt, "content-marketing", "Content Marketing chuyên nghiệp", 
                     "marketing", "Storytelling, Copywriting, SEO Content", 
                     899000, 1799000, "11 giờ", 2345, "Beginner", 0, 50);
            
            addCourse(pstmt, "social-media", "Social Media Marketing Master", 
                     "marketing", "Facebook, Instagram, TikTok, YouTube", 
                     1199000, 2399000, "16 giờ", 4123, "Intermediate", 0, 50);
            
            System.out.println("   ✓ Đã thêm 36 khóa học với tiếng Việt UTF-8");
        }
    }
    
    private static void addCourse(PreparedStatement pstmt, String id, String name, 
                                 String category, String desc, double price, double oldPrice,
                                 String duration, int students, String level, 
                                 int isNew, int discount) throws Exception {
        pstmt.setString(1, id);
        pstmt.setString(2, name);
        pstmt.setString(3, category);
        pstmt.setString(4, desc);
        pstmt.setDouble(5, price);
        pstmt.setDouble(6, oldPrice);
        pstmt.setString(7, duration);
        pstmt.setInt(8, students);
        pstmt.setString(9, level);
        pstmt.setInt(10, isNew);
        pstmt.setInt(11, discount);
        pstmt.executeUpdate();
    }
}
