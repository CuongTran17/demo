<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.servlets.AdminServlet" %>
<%@ page import="com.example.dao.OrderDAO" %>
<%@ page import="com.example.model.PendingChange" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
    String userEmail = (String) session.getAttribute("userEmail");
    String userFullname = (String) session.getAttribute("userFullname");
    
    if (loggedIn == null || !loggedIn || !"admin@ptit.edu.vn".equals(userEmail)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Get data from request attributes
    AdminServlet.AdminStats stats = (AdminServlet.AdminStats) request.getAttribute("stats");
    @SuppressWarnings("unchecked")
    List<AdminServlet.UserInfo> users = (List<AdminServlet.UserInfo>) request.getAttribute("users");
    @SuppressWarnings("unchecked")
    List<AdminServlet.TeacherInfo> teachers = (List<AdminServlet.TeacherInfo>) request.getAttribute("teachers");
    @SuppressWarnings("unchecked")
    List<AdminServlet.CourseInfo> courses = (List<AdminServlet.CourseInfo>) request.getAttribute("courses");
    @SuppressWarnings("unchecked")
    List<OrderDAO.OrderInfo> pendingPayments = (List<OrderDAO.OrderInfo>) request.getAttribute("pendingPayments");
    
    if (stats == null) stats = new AdminServlet.AdminStats();
    if (users == null) users = new java.util.ArrayList<>();
    if (teachers == null) teachers = new java.util.ArrayList<>();
    if (courses == null) courses = new java.util.ArrayList<>();
    if (pendingPayments == null) pendingPayments = new java.util.ArrayList<>();
    
    NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
%>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <title>Quản trị hệ thống – PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css?v=3" />
  <style>
    * {
      box-sizing: border-box;
    }
    
    body {
      margin: 0;
      padding: 0;
      background: #f8fafc;
    }
    
    .admin-dashboard {
      padding: 20px;
      max-width: 1400px;
      margin: 0 auto;
    }
    
    .dashboard-header {
      background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
      color: white;
      padding: 30px;
      border-radius: 15px;
      margin-bottom: 30px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      flex-wrap: wrap;
      gap: 20px;
    }
    
    .dashboard-header-content {
      flex: 1;
      min-width: 300px;
    }
    
    .dashboard-header-content h1 {
      margin: 0 0 10px 0;
      font-size: 2rem;
      font-weight: 700;
      line-height: 1.2;
    }
    
    .dashboard-header-content p {
      margin: 0;
      opacity: 0.9;
      font-size: 1rem;
      line-height: 1.5;
    }
    
    .logout-btn {
      background: rgba(255, 255, 255, 0.2);
      color: white;
      border: 2px solid white;
      padding: 12px 24px;
      border-radius: 8px;
      font-size: 0.95rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-block;
      white-space: nowrap;
    }
    
    .logout-btn:hover {
      background: white;
      color: #f5576c;
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }
    
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
      gap: 15px;
      margin-bottom: 30px;
    }
    
    .stat-card {
      background: white;
      padding: 25px;
      border-radius: 12px;
      box-shadow: 0 2px 20px rgba(0,0,0,0.08);
      text-align: center;
      border-left: 4px solid;
    }
    
    .stat-card.users { border-left-color: #3b82f6; }
    .stat-card.teachers { border-left-color: #10b981; }
    .stat-card.courses { border-left-color: #f59e0b; }
    .stat-card.orders { border-left-color: #8b5cf6; }
    .stat-card.revenue { border-left-color: #ef4444; }
    
    .stat-card h3 {
      margin: 0 0 10px 0;
      font-size: 2rem;
      font-weight: 700;
      color: #333;
      word-break: break-word;
    }
    
    .stat-card.revenue h3 {
      font-size: 1.5rem;
      line-height: 1.3;
    }
    
    .stat-card p {
      margin: 0;
      color: #666;
      font-size: 0.95rem;
    }
    
    .tab-navigation {
      display: flex;
      gap: 10px;
      margin-bottom: 30px;
      border-bottom: 2px solid #e2e8f0;
    }
    
    .tab-btn {
      padding: 12px 24px;
      background: none;
      border: none;
      border-bottom: 3px solid transparent;
      font-size: 1rem;
      font-weight: 600;
      color: #666;
      cursor: pointer;
      transition: all 0.3s ease;
    }
    
    .tab-btn.active {
      color: #f5576c;
      border-bottom-color: #f5576c;
    }
    
    .tab-content {
      display: none;
    }
    
    .tab-content.active {
      display: block;
    }
    
    .data-table {
      width: 100%;
      background: white;
      border-radius: 12px;
      box-shadow: 0 2px 20px rgba(0,0,0,0.08);
      overflow-x: auto;
      max-height: 600px;
      overflow-y: auto;
    }
    
    .data-table table {
      width: 100%;
      border-collapse: collapse;
      min-width: 600px;
    }
    
    .data-table thead {
      position: sticky;
      top: 0;
      background: #f8fafc;
      z-index: 10;
    }
    
    .data-table th {
      background: #f8fafc;
      padding: 12px 15px;
      text-align: left;
      font-weight: 600;
      color: #333;
      border-bottom: 2px solid #e2e8f0;
      font-size: 0.9rem;
      white-space: nowrap;
    }
    
    .data-table td {
      padding: 12px 15px;
      border-bottom: 1px solid #f1f5f9;
      font-size: 0.9rem;
    }
    
    .data-table tr:hover {
      background: #f8fafc;
    }
    
    .data-table tr:last-child td {
      border-bottom: none;
    }
    
    .btn {
      padding: 8px 16px;
      border: none;
      border-radius: 6px;
      font-size: 0.85rem;
      font-weight: 500;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-block;
      white-space: nowrap;
    }
    
    .btn-sm {
      padding: 6px 12px;
      font-size: 0.8rem;
    }
    
    .btn-primary {
      background: #f5576c;
      color: white;
    }
    
    .btn-primary:hover {
      background: #d63647;
      transform: translateY(-2px);
    }
    
    .btn-secondary {
      background: #e2e8f0;
      color: #333;
    }
    
    .btn-secondary:hover {
      background: #cbd5e0;
    }
    
    .btn-danger {
      background: #e53e3e;
      color: white;
    }
    
    .btn-danger:hover {
      background: #c53030;
    }
    
    .btn-success {
      background: #38a169;
      color: white;
    }
    
    .btn-success:hover {
      background: #2f855a;
    }
    
    .action-buttons {
      display: flex;
      gap: 8px;
      align-items: center;
    }
    
    .action-buttons form {
      margin: 0;
    }
    
    .modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0,0,0,0.5);
    }
    
    .modal-content {
      background-color: white;
      margin: 5% auto;
      padding: 30px;
      border-radius: 12px;
      width: 90%;
      max-width: 500px;
    }
    
    .close {
      color: #aaa;
      float: right;
      font-size: 28px;
      font-weight: bold;
      cursor: pointer;
    }
    
    .close:hover {
      color: #000;
    }
    
    .form-group {
      margin-bottom: 20px;
    }
    
    .form-group label {
      display: block;
      margin-bottom: 5px;
      font-weight: 500;
      color: #333;
    }
    
    .form-group input, .form-group select {
      width: 100%;
      padding: 12px;
      border: 1px solid #e2e8f0;
      border-radius: 8px;
      font-size: 1rem;
      transition: border-color 0.3s ease;
    }
    
    .form-group input:focus, .form-group select:focus {
      outline: none;
      border-color: #f5576c;
      box-shadow: 0 0 0 3px rgba(245, 87, 108, 0.1);
    }
    
    .badge {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 12px;
      font-size: 0.8rem;
      font-weight: 500;
      white-space: nowrap;
    }
    
    .badge-success {
      background: #d1fae5;
      color: #065f46;
    }
    
    .badge-info {
      background: #dbeafe;
      color: #1e40af;
    }
    
    .section-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 20px;
      flex-wrap: wrap;
      gap: 15px;
    }
    
    .section-header h2 {
      margin: 0;
      font-size: 1.5rem;
      font-weight: 600;
      color: #1e293b;
    }
    
    @media (max-width: 768px) {
      .dashboard-header {
        padding: 20px;
      }
      
      .dashboard-header-content h1 {
        font-size: 1.5rem;
      }
      
      .dashboard-header-content p {
        font-size: 0.9rem;
      }
      
      .stats-grid {
        grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
        gap: 10px;
      }
      
      .stat-card {
        padding: 15px;
      }
      
      .stat-card h3 {
        font-size: 1.8rem;
      }
      
      .stat-card p {
        font-size: 0.8rem;
      }
      
      .tab-navigation {
        flex-wrap: wrap;
        gap: 5px;
      }
      
      .tab-btn {
        padding: 10px 15px;
        font-size: 0.9rem;
      }
      
      .admin-dashboard {
        padding: 10px;
      }
      
      .data-table th,
      .data-table td {
        padding: 10px;
        font-size: 0.85rem;
      }
      
      .data-table {
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
        display: block;
      }
      
      .data-table table {
        min-width: 800px;
      }
    }
  </style>
</head>
<body>
  <%@ include file="/includes/header.jsp" %>

  <main class="container admin-dashboard">
    <div class="dashboard-header">
      <div class="dashboard-header-content">
        <h1>⚙️ Quản trị hệ thống</h1>
        <p>Chào mừng <%= userFullname != null ? userFullname : "Admin" %> - Quản lý toàn bộ hệ thống PTIT Learning</p>
      </div>
      <a href="${pageContext.request.contextPath}/logout" class="logout-btn">🚪 Đăng xuất</a>
    </div>

    <!-- Statistics -->
    <div class="stats-grid">
      <div class="stat-card users">
        <h3><%= stats.totalUsers %></h3>
        <p>NGƯỜI DÙNG</p>
      </div>
      
      <div class="stat-card teachers">
        <h3><%= stats.totalTeachers %></h3>
        <p>GIÁO VIÊN</p>
      </div>
      
      <div class="stat-card courses">
        <h3><%= stats.totalCourses %></h3>
        <p>KHÓA HỌC</p>
      </div>
      
      <div class="stat-card orders">
        <h3><%= stats.totalOrders %></h3>
        <p>ĐỢN HÀNG</p>
      </div>
      
      <div class="stat-card revenue">
        <h3><%= currencyFormat.format(stats.totalRevenue) %>đ</h3>
        <p>DOANH THU</p>
      </div>
    </div>

    <!-- Tabs -->
    <div class="tab-navigation">
      <button class="tab-btn active" onclick="openTab('users')">👥 Người dùng</button>
      <button class="tab-btn" onclick="openTab('teachers')">👨‍🏫 Giáo viên</button>
      <button class="tab-btn" onclick="openTab('courses')">📚 Khóa học</button>
      <button class="tab-btn" onclick="openTab('pending')">⏳ Duyệt thay đổi</button>
      <button class="tab-btn" onclick="openTab('payments')">💳 Duyệt thanh toán</button>
      <button class="tab-btn" onclick="openTab('history')">📜 Lịch sử duyệt</button>
      <button class="tab-btn" onclick="openTab('payment-history')">💰 Lịch sử thanh toán</button>
    </div>

    <!-- Users Tab -->
    <div id="users" class="tab-content active">
      <div class="section-header">
        <h2>Danh sách người dùng</h2>
      </div>
      
      <div class="data-table">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Email</th>
              <th>Họ tên</th>
              <th>Số điện thoại</th>
              <th>Ngày tạo</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <% for (AdminServlet.UserInfo user : users) { %>
            <tr>
              <td><%= user.userId %></td>
              <td><%= user.email %></td>
              <td><%= user.fullname != null ? user.fullname : "-" %></td>
              <td><%= user.phone != null ? user.phone : "-" %></td>
              <td><%= user.createdAt != null ? new java.text.SimpleDateFormat("dd/MM/yyyy").format(user.createdAt) : "-" %></td>
              <td>
                <% if (!"admin@ptit.edu.vn".equals(user.email)) { %>
                <button class="btn btn-danger btn-sm" onclick="deleteUser(<%= user.userId %>)">Xóa</button>
                <% } else { %>
                <span class="badge badge-success">Admin</span>
                <% } %>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Teachers Tab -->
    <div id="teachers" class="tab-content">
      <div class="section-header">
        <h2>Danh sách giáo viên</h2>
        <button class="btn btn-primary" onclick="openCreateTeacherModal()">➕ Tạo tài khoản giáo viên</button>
      </div>
      
      <div class="data-table">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Email</th>
              <th>Họ tên</th>
              <th>Số khóa học</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <% for (AdminServlet.TeacherInfo teacher : teachers) { %>
            <tr>
              <td><%= teacher.userId %></td>
              <td><%= teacher.email %></td>
              <td><%= teacher.fullname != null ? teacher.fullname : "-" %></td>
              <td><span class="badge badge-info"><%= teacher.courseCount %> khóa</span></td>
              <td>
                <button class="btn btn-secondary btn-sm" onclick="openAssignCourseModal(<%= teacher.userId %>, '<%= teacher.fullname %>')">Gán khóa học</button>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Courses Tab -->
    <div id="courses" class="tab-content">
      <div class="section-header">
        <h2>Danh sách khóa học</h2>
      </div>
      
      <div class="data-table">
        <table>
          <thead>
            <tr>
              <th>Mã khóa học</th>
              <th>Tên khóa học</th>
              <th>Danh mục</th>
              <th>Giá</th>
              <th>Số học viên</th>
            </tr>
          </thead>
          <tbody>
            <% for (AdminServlet.CourseInfo course : courses) { %>
            <tr>
              <td><%= course.courseId %></td>
              <td><%= course.courseName %></td>
              <td><span class="badge badge-info"><%= course.category %></span></td>
              <td><%= currencyFormat.format(course.price) %>đ</td>
              <td><%= course.enrolledCount %> học viên</td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Pending Changes Tab -->
    <div id="pending" class="tab-content">
      <div class="section-header">
        <h2>Yêu cầu duyệt thay đổi</h2>
        <div class="section-actions">
          <span class="badge badge-warning"><%= request.getAttribute("pendingCount") %> yêu cầu chờ duyệt</span>
        </div>
      </div>
      
      <div class="data-table">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Giáo viên</th>
              <th>Loại thay đổi</th>
              <th>Đối tượng</th>
              <th>Nội dung thay đổi</th>
              <th>Thời gian</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <% 
            @SuppressWarnings("unchecked")
            List<com.example.model.PendingChange> pendingChanges = (List<com.example.model.PendingChange>) request.getAttribute("pendingChanges");
            if (pendingChanges != null) {
              for (com.example.model.PendingChange change : pendingChanges) { 
            %>
            <tr>
              <td><%= change.getChangeId() %></td>
              <td>
                <div>
                  <strong><%= change.getTeacherName() %></strong><br>
                  <small><%= change.getTeacherEmail() %></small>
                </div>
              </td>
              <td>
                <span class="badge badge-info">
                  <% 
                  String type = change.getChangeType();
                  if ("course_create".equals(type)) out.print("Tạo khóa học");
                  else if ("course_update".equals(type)) out.print("Cập nhật khóa học");
                  else if ("lesson_create".equals(type)) out.print("Tạo bài học");
                  else if ("lesson_update".equals(type)) out.print("Cập nhật bài học");
                  else if ("lesson_delete".equals(type)) out.print("Xóa bài học");
                  else out.print(type);
                  %>
                </span>
              </td>
              <td>
                <% 
                String targetDisplay = "";
                String changeType = change.getChangeType();
                if ("course_create".equals(changeType)) {
                  targetDisplay = "Khóa học mới: " + change.getTargetId();
                } else if ("course_update".equals(changeType)) {
                  targetDisplay = "Khóa học: " + change.getTargetId();
                } else if (changeType.contains("lesson")) {
                  targetDisplay = "Bài học: " + change.getTargetId();
                } else {
                  targetDisplay = change.getTargetId();
                }
                %>
                <%= targetDisplay %>
              </td>
              <td>
                <div style="max-width: 300px;">
                  <% 
                  String data = change.getChangeData();
                  System.out.println("DEBUG - Change ID " + change.getChangeId() + " data: " + data);
                  if ("{}".equals(data)) {
                    out.print("Không có dữ liệu");
                  } else {
                    // Check if data contains image_filename for image preview
                    if (data != null && data.contains("image_filename")) {
                      System.out.println("DEBUG - Found image_filename in data");
                      // Extract image path - handle both escaped and unescaped quotes
                      String imgPattern = "image_filename";
                      int imgStart = data.indexOf(imgPattern);
                      if (imgStart >= 0) {
                        // Find the colon after image_filename
                        int colonPos = data.indexOf(":", imgStart);
                        if (colonPos > 0) {
                          // Find the opening quote
                          int quoteStart = data.indexOf("\"", colonPos);
                          if (quoteStart > 0) {
                            quoteStart++; // Move past the quote
                            // Find the closing quote
                            int quoteEnd = data.indexOf("\"", quoteStart);
                            if (quoteEnd > quoteStart) {
                              String imgPath = data.substring(quoteStart, quoteEnd);
                              System.out.println("DEBUG - Extracted image path: " + imgPath);
                  %>
                          <div style="margin-bottom: 8px; padding: 8px; background: #f8f9fa; border-radius: 4px;">
                            <strong style="color: #667eea;">📷 Hình ảnh mới:</strong><br>
                            <img src="<%= request.getContextPath() + "/" + imgPath %>" 
                                 alt="Preview" 
                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='block';"
                                 style="max-width: 200px; max-height: 150px; border: 2px solid #667eea; border-radius: 4px; margin-top: 4px; display: block;">
                            <div style="display: none; color: #e53e3e; margin-top: 4px;">❌ Không thể tải ảnh</div>
                          </div>
                  <%    
                            }
                          }
                        }
                      }
                    }
                    // Display JSON data in a collapsed format
                  %>
                  <details style="cursor: pointer;">
                    <summary style="color: #666; font-size: 0.9em;">📄 Chi tiết JSON</summary>
                    <div style="overflow: auto; max-height: 100px; padding: 4px; background: #f5f5f5; border-radius: 4px; margin-top: 4px; font-size: 0.85em; word-break: break-all;">
                      <%= data %>
                    </div>
                  </details>
                  <% } %>
                </div>
              </td>
              <td><%= change.getCreatedAt() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(change.getCreatedAt()) : "-" %></td>
              <td>
                <div style="display: flex; gap: 5px;">
                  <form method="POST" action="${pageContext.request.contextPath}/admin" style="display: inline;">
                    <input type="hidden" name="action" value="approveChange">
                    <input type="hidden" name="changeId" value="<%= change.getChangeId() %>">
                    <input type="text" name="note" placeholder="Ghi chú (tùy chọn)" style="width: 120px; padding: 2px 4px; font-size: 12px;">
                    <button type="submit" class="btn btn-success btn-sm" onclick="return confirm('Duyệt thay đổi này?')">✓ Duyệt</button>
                  </form>
                  <form method="POST" action="${pageContext.request.contextPath}/admin" style="display: inline;">
                    <input type="hidden" name="action" value="rejectChange">
                    <input type="hidden" name="changeId" value="<%= change.getChangeId() %>">
                    <input type="text" name="note" placeholder="Lý do từ chối" style="width: 120px; padding: 2px 4px; font-size: 12px;">
                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Từ chối thay đổi này?')">✗ Từ chối</button>
                  </form>
                </div>
              </td>
            </tr>
            <% } } %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- History Tab -->
    <div id="history" class="tab-content">
      <div class="section-header">
        <h2>Lịch sử duyệt thay đổi</h2>
        <div class="section-actions">
          <span class="badge badge-info">Tất cả các thay đổi đã được xử lý</span>
        </div>
      </div>
      
      <div class="data-table">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Giáo viên</th>
              <th>Loại thay đổi</th>
              <th>Đối tượng</th>
              <th>Nội dung thay đổi</th>
              <th>Trạng thái</th>
              <th>Ngày gửi</th>
              <th>Ngày duyệt</th>
              <th>Người duyệt</th>
              <th>Ghi chú</th>
            </tr>
          </thead>
          <tbody>
            <% 
            @SuppressWarnings("unchecked")
            List<com.example.model.PendingChange> reviewedChanges = (List<com.example.model.PendingChange>) request.getAttribute("reviewedChanges");
            if (reviewedChanges != null && !reviewedChanges.isEmpty()) {
              for (com.example.model.PendingChange change : reviewedChanges) { 
            %>
            <tr>
              <td><%= change.getChangeId() %></td>
              <td>
                <div>
                  <strong><%= change.getTeacherName() %></strong><br>
                  <small><%= change.getTeacherEmail() %></small>
                </div>
              </td>
              <td>
                <span class="badge badge-info">
                  <% 
                  String type = change.getChangeType();
                  if ("course_create".equals(type)) out.print("Tạo khóa học");
                  else if ("course_update".equals(type)) out.print("Cập nhật khóa học");
                  else if ("lesson_create".equals(type)) out.print("Tạo bài học");
                  else if ("lesson_update".equals(type)) out.print("Cập nhật bài học");
                  else if ("lesson_delete".equals(type)) out.print("Xóa bài học");
                  else out.print(type);
                  %>
                </span>
              </td>
              <td>
                <% 
                String targetDisplay = "";
                String changeType = change.getChangeType();
                if ("course_create".equals(changeType)) {
                  targetDisplay = "Khóa học mới: " + change.getTargetId();
                } else if ("course_update".equals(changeType)) {
                  targetDisplay = "Khóa học: " + change.getTargetId();
                } else if (changeType.contains("lesson")) {
                  targetDisplay = "Bài học: " + change.getTargetId();
                } else {
                  targetDisplay = change.getTargetId();
                }
                %>
                <%= targetDisplay %>
              </td>
              <td>
                <div style="max-width: 200px;">
                  <% 
                  String dataHist = change.getChangeData();
                  if ("{}".equals(dataHist)) {
                    out.print("Không có dữ liệu");
                  } else {
                    // Check if data contains image_filename for image preview
                    if (dataHist != null && dataHist.contains("image_filename")) {
                      // Extract image path - handle both escaped and unescaped quotes
                      String imgPatternHist = "image_filename";
                      int imgStartHist = dataHist.indexOf(imgPatternHist);
                      if (imgStartHist >= 0) {
                        // Find the colon after image_filename
                        int colonPosHist = dataHist.indexOf(":", imgStartHist);
                        if (colonPosHist > 0) {
                          // Find the opening quote
                          int quoteStartHist = dataHist.indexOf("\"", colonPosHist);
                          if (quoteStartHist > 0) {
                            quoteStartHist++; // Move past the quote
                            // Find the closing quote
                            int quoteEndHist = dataHist.indexOf("\"", quoteStartHist);
                            if (quoteEndHist > quoteStartHist) {
                              String imgPathHist = dataHist.substring(quoteStartHist, quoteEndHist);
                  %>
                          <div style="margin-bottom: 8px; padding: 6px; background: #f8f9fa; border-radius: 4px;">
                            <strong style="color: #667eea;">📷 Hình ảnh:</strong><br>
                            <img src="<%= request.getContextPath() + "/" + imgPathHist %>" 
                                 alt="Preview" 
                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='block';"
                                 style="max-width: 150px; max-height: 100px; border: 2px solid #667eea; border-radius: 4px; margin-top: 4px; display: block;">
                            <div style="display: none; color: #e53e3e; margin-top: 4px; font-size: 0.85em;">❌ Lỗi tải ảnh</div>
                          </div>
                  <%    
                            }
                          }
                        }
                      }
                    }
                    // Display JSON data in a collapsed format
                  %>
                  <details style="cursor: pointer;">
                    <summary style="color: #666; font-size: 0.85em;">📄 Chi tiết</summary>
                    <div style="overflow: auto; max-height: 80px; padding: 4px; background: #f5f5f5; border-radius: 4px; margin-top: 4px; font-size: 0.8em; word-break: break-all;">
                      <%= dataHist %>
                    </div>
                  </details>
                  <% } %>
                </div>
              </td>
              <td>
                <% if ("approved".equals(change.getStatus())) { %>
                  <span class="badge badge-success">✓ Đã duyệt</span>
                <% } else if ("rejected".equals(change.getStatus())) { %>
                  <span class="badge badge-danger">✗ Đã từ chối</span>
                <% } %>
              </td>
              <td><%= change.getCreatedAt() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(change.getCreatedAt()) : "-" %></td>
              <td><%= change.getReviewedAt() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(change.getReviewedAt()) : "-" %></td>
              <td><%= change.getReviewerName() != null ? change.getReviewerName() : "-" %></td>
              <td><%= change.getReviewNote() != null ? change.getReviewNote() : "-" %></td>
            </tr>
            <% 
              } 
            } else {
            %>
            <tr>
              <td colspan="10" style="text-align: center; padding: 30px; color: #64748b;">
                Chưa có lịch sử duyệt thay đổi
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Payments Tab -->
    <div id="payments" class="tab-content">
      <div class="section-header">
        <h2>Đơn hàng chờ duyệt thanh toán</h2>
        <div class="section-actions">
          <span class="badge badge-warning"><%= pendingPayments.size() %> đơn hàng chờ duyệt</span>
        </div>
      </div>
      
      <div class="data-table">
        <table>
          <thead>
            <tr>
              <th>ID Đơn hàng</th>
              <th>Khách hàng</th>
              <th>Email</th>
              <th>Số điện thoại</th>
              <th>Tổng tiền</th>
              <th>Phương thức</th>
              <th>Ghi chú</th>
              <th>Ngày đặt</th>
              <th>Thao tác</th>
            </tr>
          </thead>
          <tbody>
            <% 
            if (pendingPayments != null && !pendingPayments.isEmpty()) {
              for (OrderDAO.OrderInfo payment : pendingPayments) { 
            %>
            <tr>
              <td>#<%= payment.orderId %></td>
              <td><%= payment.userFullname %></td>
              <td><%= payment.userEmail %></td>
              <td><%= payment.userPhone %></td>
              <td class="price"><%= currencyFormat.format(payment.totalAmount) %> VND</td>
              <td>
                <span class="badge badge-info"><%= payment.paymentMethod.equals("vietqr") ? "VietQR" : payment.paymentMethod %></span>
              </td>
              <td><%= payment.orderNote != null ? payment.orderNote : "Không có ghi chú" %></td>
              <td><%= payment.createdAt %></td>
              <td>
                <div class="action-buttons">
                  <form method="post" action="${pageContext.request.contextPath}/admin" style="display: inline;">
                    <input type="hidden" name="action" value="approvePayment">
                    <input type="hidden" name="orderId" value="<%= payment.orderId %>">
                    <button type="submit" class="btn btn-success btn-sm" onclick="return confirm('Bạn có chắc muốn duyệt đơn hàng này?')">✓ Duyệt</button>
                  </form>
                  <form method="post" action="${pageContext.request.contextPath}/admin" style="display: inline;">
                    <input type="hidden" name="action" value="rejectPayment">
                    <input type="hidden" name="orderId" value="<%= payment.orderId %>">
                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc muốn từ chối đơn hàng này?')">✗ Từ chối</button>
                  </form>
                </div>
              </td>
            </tr>
            <% 
              }
            } else {
            %>
            <tr>
              <td colspan="9" style="text-align: center; padding: 30px; color: #64748b;">
                Không có đơn hàng nào chờ duyệt thanh toán
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Payment History Tab -->
    <div id="payment-history" class="tab-content">
      <div class="section-header">
        <h2>Lịch sử duyệt thanh toán</h2>
        <div class="section-actions">
          <span class="badge badge-info">100 giao dịch gần nhất</span>
        </div>
      </div>
      
      <div class="data-table">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Đơn hàng</th>
              <th>Khách hàng</th>
              <th>Số tiền</th>
              <th>Phương thức</th>
              <th>Hành động</th>
              <th>Trạng thái cũ</th>
              <th>Trạng thái mới</th>
              <th>Người duyệt</th>
              <th>Ghi chú</th>
              <th>Thời gian</th>
            </tr>
          </thead>
          <tbody>
            <% 
            @SuppressWarnings("unchecked")
            List<OrderDAO.PaymentApprovalHistory> paymentHistory = (List<OrderDAO.PaymentApprovalHistory>) request.getAttribute("paymentHistory");
            if (paymentHistory != null && !paymentHistory.isEmpty()) {
              for (OrderDAO.PaymentApprovalHistory history : paymentHistory) { 
            %>
            <tr>
              <td>#<%= history.historyId %></td>
              <td>#<%= history.orderId %></td>
              <td><%= history.userFullname %></td>
              <td class="price"><%= currencyFormat.format(history.totalAmount) %> VND</td>
              <td>
                <span class="badge badge-info"><%= history.paymentMethod.equals("vietqr") ? "VietQR" : history.paymentMethod %></span>
              </td>
              <td>
                <% if ("approved".equals(history.action)) { %>
                  <span class="badge badge-success">✓ Đã duyệt</span>
                <% } else if ("rejected".equals(history.action)) { %>
                  <span class="badge badge-danger">✗ Từ chối</span>
                <% } else { %>
                  <span class="badge badge-secondary"><%= history.action %></span>
                <% } %>
              </td>
              <td><span class="badge badge-warning"><%= history.oldStatus %></span></td>
              <td>
                <% if ("completed".equals(history.newStatus)) { %>
                  <span class="badge badge-success"><%= history.newStatus %></span>
                <% } else if ("rejected".equals(history.newStatus)) { %>
                  <span class="badge badge-danger"><%= history.newStatus %></span>
                <% } else { %>
                  <span class="badge badge-info"><%= history.newStatus %></span>
                <% } %>
              </td>
              <td><strong><%= history.adminFullname %></strong></td>
              <td><%= history.note != null && !history.note.isEmpty() ? history.note : "-" %></td>
              <td><%= history.createdAt %></td>
            </tr>
            <% 
              }
            } else {
            %>
            <tr>
              <td colspan="11" style="text-align: center; padding: 30px; color: #64748b;">
                Chưa có lịch sử duyệt thanh toán
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </main>

  <!-- Create Teacher Modal -->
  <div id="createTeacherModal" class="modal">
    <div class="modal-content">
      <span class="close" onclick="closeModal('createTeacherModal')">&times;</span>
      <h2>Tạo tài khoản giáo viên</h2>
      <form method="POST" action="${pageContext.request.contextPath}/admin">
        <input type="hidden" name="action" value="createTeacher">
        
        <div class="form-group">
          <label>Email *</label>
          <input type="email" name="email" required placeholder="teacher@ptit.edu.vn">
        </div>
        
        <div class="form-group">
          <label>Mật khẩu *</label>
          <input type="password" name="password" required placeholder="Nhập mật khẩu">
        </div>
        
        <div class="form-group">
          <label>Họ tên *</label>
          <input type="text" name="fullname" required placeholder="Nguyễn Văn A">
        </div>
        
        <div class="form-group">
          <label>Số điện thoại</label>
          <input type="tel" name="phone" placeholder="0123456789">
        </div>
        
        <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px;">
          <button type="button" class="btn btn-secondary" onclick="closeModal('createTeacherModal')">Hủy</button>
          <button type="submit" class="btn btn-primary">Tạo tài khoản</button>
        </div>
      </form>
    </div>
  </div>

  <!-- Assign Course Modal -->
  <div id="assignCourseModal" class="modal">
    <div class="modal-content">
      <span class="close" onclick="closeModal('assignCourseModal')">&times;</span>
      <h2>Gán khóa học cho giáo viên</h2>
      <p id="teacherNameDisplay" style="margin-bottom: 20px; color: #666;"></p>
      <form method="POST" action="${pageContext.request.contextPath}/admin">
        <input type="hidden" name="action" value="assignCourse">
        <input type="hidden" name="teacherId" id="assignTeacherId">
        
        <div class="form-group">
          <label>Chọn khóa học *</label>
          <select name="courseId" required>
            <option value="">-- Chọn khóa học --</option>
            <% for (AdminServlet.CourseInfo course : courses) { %>
            <option value="<%= course.courseId %>"><%= course.courseName %> (<%= course.category %>)</option>
            <% } %>
          </select>
        </div>
        
        <div style="display: flex; gap: 10px; justify-content: flex-end; margin-top: 20px;">
          <button type="button" class="btn btn-secondary" onclick="closeModal('assignCourseModal')">Hủy</button>
          <button type="submit" class="btn btn-primary">Gán khóa học</button>
        </div>
      </form>
    </div>
  </div>

  <script>
    function openTab(tabName) {
      const tabs = document.querySelectorAll('.tab-content');
      const btns = document.querySelectorAll('.tab-btn');
      
      tabs.forEach(tab => tab.classList.remove('active'));
      btns.forEach(btn => btn.classList.remove('active'));
      
      document.getElementById(tabName).classList.add('active');
      event.target.classList.add('active');
    }
    
    function openCreateTeacherModal() {
      document.getElementById('createTeacherModal').style.display = 'block';
    }
    
    function openAssignCourseModal(teacherId, teacherName) {
      document.getElementById('assignTeacherId').value = teacherId;
      document.getElementById('teacherNameDisplay').textContent = 'Giáo viên: ' + teacherName;
      document.getElementById('assignCourseModal').style.display = 'block';
    }
    
    function closeModal(modalId) {
      document.getElementById(modalId).style.display = 'none';
    }
    
    function deleteUser(userId) {
      if (confirm('Bạn có chắc chắn muốn xóa người dùng này?')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'deleteUser';
        
        const userIdInput = document.createElement('input');
        userIdInput.type = 'hidden';
        userIdInput.name = 'userId';
        userIdInput.value = userId;
        
        form.appendChild(actionInput);
        form.appendChild(userIdInput);
        document.body.appendChild(form);
        form.submit();
      }
    }
    
    // Close modal when clicking outside
    window.onclick = function(event) {
      if (event.target.classList.contains('modal')) {
        event.target.style.display = 'none';
      }
    }
  </script>
</body>
</html>
