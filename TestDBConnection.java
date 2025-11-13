import java.sql.*;

public class TestDBConnection {
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/ptit_learning?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
        String user = "root";
        String password = "NTHair935@";
        
        System.out.println("Attempting to connect to database...");
        System.out.println("URL: " + url);
        System.out.println("User: " + user);
        System.out.println();
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, user, password);
            System.out.println("✓ Database connection successful!");
            System.out.println();
            
            // Query users
            String query = "SELECT user_id, email, phone, fullname, created_at FROM users";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);
            
            System.out.println("=== USER ACCOUNTS ===");
            System.out.println("-".repeat(80));
            System.out.printf("%-5s %-30s %-15s %-25s %-20s%n", 
                "ID", "Email", "Phone", "Full Name", "Created At");
            System.out.println("-".repeat(80));
            
            while (rs.next()) {
                System.out.printf("%-5d %-30s %-15s %-25s %-20s%n",
                    rs.getInt("user_id"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("fullname"),
                    rs.getTimestamp("created_at")
                );
            }
            System.out.println("-".repeat(80));
            System.out.println();
            
            // Get password hash for the first user
            String passQuery = "SELECT email, password_hash FROM users LIMIT 1";
            rs = stmt.executeQuery(passQuery);
            if (rs.next()) {
                System.out.println("=== TEST ACCOUNT CREDENTIALS ===");
                System.out.println("Email: " + rs.getString("email"));
                System.out.println("Password: 123456 (plain text)");
                System.out.println("Password Hash: " + rs.getString("password_hash"));
                System.out.println();
                System.out.println("NOTE: The default password is '123456' (SHA-256 hashed in database)");
            }
            
            rs.close();
            stmt.close();
            conn.close();
            
        } catch (ClassNotFoundException e) {
            System.err.println("✗ MySQL JDBC Driver not found!");
            System.err.println("Make sure mysql-connector-j is in the classpath");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("✗ Database connection failed!");
            System.err.println("Error: " + e.getMessage());
            System.err.println();
            System.err.println("Possible issues:");
            System.err.println("1. MySQL service is not running");
            System.err.println("2. Database 'ptit_learning' doesn't exist");
            System.err.println("3. Wrong username/password (current: root/123456789)");
            System.err.println("4. Port 3306 is blocked");
            e.printStackTrace();
        }
    }
}
