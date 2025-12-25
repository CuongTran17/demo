<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.servlets.UserRevenueServlet" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
    String userEmail = (String) session.getAttribute("userEmail");
    String userFullname = (String) session.getAttribute("userFullname");
    
    if (loggedIn == null || !loggedIn || !"admin@ptit.edu.vn".equals(userEmail)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<UserRevenueServlet.UserRevenueDetail> userRevenues = 
        (List<UserRevenueServlet.UserRevenueDetail>) request.getAttribute("userRevenues");
    
    BigDecimal totalRevenue = (BigDecimal) request.getAttribute("totalRevenue");
    Integer totalOrders = (Integer) request.getAttribute("totalOrders");
    Integer totalUsers = (Integer) request.getAttribute("totalUsers");
    
    if (userRevenues == null) userRevenues = new java.util.ArrayList<>();
    if (totalRevenue == null) totalRevenue = BigDecimal.ZERO;
    if (totalOrders == null) totalOrders = 0;
    if (totalUsers == null) totalUsers = 0;
    
    NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <title>Chi Tiết Doanh Thu Theo Người Dùng – PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css?v=3" />
  <style>
    body {
      margin: 0;
      padding: 0;
      background: #f8fafc;
      font-family: 'Be Vietnam Pro', sans-serif;
    }
    
    .page-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 40px 20px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    }
    
    .page-header .container {
      max-width: 1400px;
      margin: 0 auto;
    }
    
    .page-header h1 {
      margin: 0 0 10px 0;
      font-size: 2rem;
      font-weight: 700;
    }
    
    .page-header .breadcrumb {
      display: flex;
      gap: 10px;
      align-items: center;
      font-size: 0.9rem;
      opacity: 0.9;
    }
    
    .page-header .breadcrumb a {
      color: white;
      text-decoration: none;
      transition: opacity 0.3s;
    }
    
    .page-header .breadcrumb a:hover {
      opacity: 0.8;
    }
    
    .container {
      max-width: 1400px;
      margin: 0 auto;
      padding: 30px 20px;
    }
    
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
      margin-bottom: 30px;
    }
    
    .stat-card {
      background: white;
      padding: 25px;
      border-radius: 12px;
      box-shadow: 0 2px 15px rgba(0,0,0,0.08);
      transition: transform 0.3s, box-shadow 0.3s;
    }
    
    .stat-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 4px 25px rgba(0,0,0,0.12);
    }
    
    .stat-card .label {
      font-size: 0.9rem;
      color: #64748b;
      margin-bottom: 10px;
    }
    
    .stat-card .value {
      font-size: 2rem;
      font-weight: 700;
      color: #1e293b;
    }
    
    .stat-card.primary .value {
      color: #10b981;
    }
    
    .stat-card.secondary .value {
      color: #3b82f6;
    }
    
    .stat-card.tertiary .value {
      color: #f59e0b;
    }
    
    .user-revenue-card {
      background: white;
      border-radius: 12px;
      box-shadow: 0 2px 15px rgba(0,0,0,0.08);
      margin-bottom: 20px;
      overflow: hidden;
      transition: transform 0.3s, box-shadow 0.3s;
    }
    
    .user-revenue-card:hover {
      transform: translateY(-3px);
      box-shadow: 0 4px 25px rgba(0,0,0,0.12);
    }
    
    .user-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 20px 25px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 15px;
    }
    
    .user-info h3 {
      margin: 0 0 5px 0;
      font-size: 1.3rem;
      font-weight: 600;
    }
    
    .user-info p {
      margin: 0;
      opacity: 0.9;
      font-size: 0.9rem;
    }
    
    .user-stats {
      display: flex;
      gap: 30px;
    }
    
    .user-stat {
      text-align: center;
    }
    
    .user-stat .label {
      font-size: 0.8rem;
      opacity: 0.8;
      margin-bottom: 5px;
    }
    
    .user-stat .value {
      font-size: 1.2rem;
      font-weight: 700;
    }
    
    .courses-table {
      padding: 25px;
    }
    
    .courses-table h4 {
      margin: 0 0 20px 0;
      color: #1e293b;
      font-size: 1.1rem;
      font-weight: 600;
    }
    
    table {
      width: 100%;
      border-collapse: collapse;
    }
    
    table thead {
      background: #f8fafc;
    }
    
    table th {
      padding: 12px 15px;
      text-align: left;
      font-weight: 600;
      color: #475569;
      border-bottom: 2px solid #e2e8f0;
      font-size: 0.9rem;
    }
    
    table td {
      padding: 15px;
      border-bottom: 1px solid #f1f5f9;
      color: #334155;
    }
    
    table tbody tr:hover {
      background: #f8fafc;
    }
    
    .badge {
      display: inline-block;
      padding: 5px 12px;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 500;
    }
    
    .badge-python { background: #dbeafe; color: #1e40af; }
    .badge-finance { background: #dcfce7; color: #15803d; }
    .badge-data { background: #fef3c7; color: #92400e; }
    .badge-marketing { background: #fce7f3; color: #9f1239; }
    .badge-blockchain { background: #e0e7ff; color: #3730a3; }
    .badge-accounting { background: #fce7f3; color: #831843; }
    
    .badge-pending { 
      background: #fef3c7; 
      color: #92400e; 
      padding: 4px 10px;
      border-radius: 12px;
      font-size: 0.75rem;
    }
    
    .badge-approved { 
      background: #dcfce7; 
      color: #15803d; 
      padding: 4px 10px;
      border-radius: 12px;
      font-size: 0.75rem;
    }
    
    .badge-rejected { 
      background: #fee2e2; 
      color: #991b1b; 
      padding: 4px 10px;
      border-radius: 12px;
      font-size: 0.75rem;
    }
    
    .price {
      font-weight: 600;
      color: #10b981;
      font-size: 1rem;
    }
    
    .back-btn {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 12px 24px;
      background: white;
      color: #667eea;
      border: 2px solid #667eea;
      border-radius: 8px;
      text-decoration: none;
      font-weight: 600;
      transition: all 0.3s;
      margin-bottom: 20px;
    }
    
    .back-btn:hover {
      background: #667eea;
      color: white;
      transform: translateX(-5px);
    }
    
    .empty-state {
      text-align: center;
      padding: 60px 20px;
      color: #64748b;
    }
    
    .empty-state svg {
      width: 80px;
      height: 80px;
      margin-bottom: 20px;
      opacity: 0.5;
    }
    
    @media (max-width: 768px) {
      .page-header h1 {
        font-size: 1.5rem;
      }
      
      .stats-grid {
        grid-template-columns: 1fr;
      }
      
      .user-header {
        flex-direction: column;
        align-items: flex-start;
      }
      
      .user-stats {
        width: 100%;
        justify-content: space-between;
      }
      
      table {
        font-size: 0.85rem;
      }
      
      table th, table td {
        padding: 10px 8px;
      }
    }
  </style>
</head>
<body>
  <div class="page-header">
    <div class="container">
      <h1>📊 Chi Tiết Doanh Thu Theo Người Dùng</h1>
      <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/admin">Quản trị</a>
        <span>›</span>
        <span>Doanh thu chi tiết</span>
      </div>
    </div>
  </div>
  
  <div class="container">
    <a href="${pageContext.request.contextPath}/admin" class="back-btn">
      <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M12.5 15L7.5 10L12.5 5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
      Quay lại Dashboard
    </a>
    
    <!-- Summary Statistics -->
    <div class="stats-grid">
      <div class="stat-card primary">
        <div class="label">💰 Tổng doanh thu</div>
        <div class="value"><%= currencyFormat.format(totalRevenue) %>đ</div>
      </div>
      <div class="stat-card secondary">
        <div class="label">👥 Tổng số người dùng</div>
        <div class="value"><%= totalUsers %></div>
      </div>
      <div class="stat-card tertiary">
        <div class="label">📦 Tổng số đơn hàng</div>
        <div class="value"><%= totalOrders %></div>
      </div>
    </div>
    
    <!-- User Revenue Details -->
    <% if (userRevenues.isEmpty()) { %>
      <div class="user-revenue-card">
        <div class="empty-state">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M9 2C8.44772 2 8 2.44772 8 3V4H6C4.89543 4 4 4.89543 4 6V20C4 21.1046 4.89543 22 6 22H18C19.1046 22 20 21.1046 20 20V6C20 4.89543 19.1046 4 18 4H16V3C16 2.44772 15.5523 2 15 2C14.4477 2 14 2.44772 14 3V4H10V3C10 2.44772 9.55228 2 9 2Z" stroke="currentColor" stroke-width="2"/>
          </svg>
          <h3>Chưa có dữ liệu doanh thu</h3>
          <p>Hiện tại chưa có người dùng nào mua khóa học.</p>
        </div>
      </div>
    <% } else { %>
      <% 
      int rank = 1;
      for (UserRevenueServlet.UserRevenueDetail userRevenue : userRevenues) { 
      %>
        <div class="user-revenue-card">
          <div class="user-header">
            <div class="user-info">
              <h3>#<%= rank++ %> <%= userRevenue.fullname != null ? userRevenue.fullname : "Người dùng" %></h3>
              <p>
                📧 <%= userRevenue.email != null ? userRevenue.email : "-" %>
                <% if (userRevenue.phone != null && !userRevenue.phone.isEmpty()) { %>
                  | 📱 <%= userRevenue.phone %>
                <% } %>
              </p>
            </div>
            <div class="user-stats">
              <div class="user-stat">
                <div class="label">Tổng chi tiêu</div>
                <div class="value"><%= currencyFormat.format(userRevenue.totalSpent) %>đ</div>
              </div>
              <div class="user-stat">
                <div class="label">Số đơn hàng</div>
                <div class="value"><%= userRevenue.orderCount %></div>
              </div>
              <div class="user-stat">
                <div class="label">Số khóa học</div>
                <div class="value"><%= userRevenue.purchasedCourses.size() %></div>
              </div>
            </div>
          </div>
          
          <div class="courses-table">
            <h4>📚 Danh sách khóa học đã mua</h4>
            <div style="overflow-x: auto;">
              <table>
                <thead>
                  <tr>
                    <th>STT</th>
                    <th>Khóa học</th>
                    <th>Danh mục</th>
                    <th>Giá</th>
                    <th>Trạng thái</th>
                    <th>Ngày mua</th>
                    <th>Mã đơn</th>
                  </tr>
                </thead>
                <tbody>
                  <% 
                  int courseNum = 1;
                  for (UserRevenueServlet.CourseOrderDetail course : userRevenue.purchasedCourses) { 
                    String badgeClass = "badge badge-" + course.category.toLowerCase();
                    String statusText = "";
                    String statusBadge = "";
                    if ("approved".equals(course.status)) {
                      statusText = "✓ Đã duyệt";
                      statusBadge = "badge-approved";
                    } else if ("pending".equals(course.status)) {
                      statusText = "⏳ Chờ duyệt";
                      statusBadge = "badge-pending";
                    } else if ("rejected".equals(course.status)) {
                      statusText = "✗ Từ chối";
                      statusBadge = "badge-rejected";
                    } else {
                      statusText = course.status;
                      statusBadge = "badge-pending";
                    }
                  %>
                    <tr>
                      <td><%= courseNum++ %></td>
                      <td><strong><%= course.courseName %></strong></td>
                      <td><span class="<%= badgeClass %>"><%= course.category %></span></td>
                      <td class="price"><%= currencyFormat.format(course.price) %>đ</td>
                      <td><span class="badge <%= statusBadge %>"><%= statusText %></span></td>
                      <td><%= dateFormat.format(course.purchaseDate) %></td>
                      <td>#<%= course.orderId %></td>
                    </tr>
                  <% } %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      <% } %>
    <% } %>
  </div>
</body>
</html>
