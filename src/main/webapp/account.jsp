<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.servlets.AccountServlet" %>
<%
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
    String userEmail = (String) session.getAttribute("userEmail");
    String userPhone = (String) session.getAttribute("userPhone");
    String userFullname = (String) session.getAttribute("userFullname");
    
    if (loggedIn == null || !loggedIn) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Get data from request attributes (set by AccountServlet)
    @SuppressWarnings("unchecked")
    List<AccountServlet.OrderInfo> orders = (List<AccountServlet.OrderInfo>) request.getAttribute("orders");
    AccountServlet.ProgressStats stats = (AccountServlet.ProgressStats) request.getAttribute("stats");
    
    if (orders == null) orders = new java.util.ArrayList<>();
    if (stats == null) stats = new AccountServlet.ProgressStats();
%>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <title>Quản lý tài khoản – PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css?v=2" />
</head>
<body>
  <%@ include file="/includes/header.jsp" %>

  <main class="container account-page">
    <h1 class="page-title">Tài khoản của tôi</h1>
    <div class="account-layout">
      <aside class="account-sidebar">
        <nav class="sidebar-nav">
          <a href="#" class="nav-item active" data-tab="progress">Tiến độ học tập</a>
          <a href="#" class="nav-item" data-tab="courses">Khóa học của tôi</a>
          <a href="#" class="nav-item" data-tab="info">Thay đổi thông tin</a>
          <a href="#" class="nav-item" data-tab="password">Thay đổi mật khẩu</a>
        </nav>
      </aside>

      <section class="account-content">
        <div class="tab-panel active" id="progress-tab">
          <div class="stats-grid">
            <div class="stat-box">
              <div class="stat-label">Tổng khóa học</div>
              <div class="stat-value"><%= stats.totalCourses %></div>
            </div>
            <div class="stat-box">
              <div class="stat-label">Số khóa học đã hoàn thành</div>
              <div class="stat-value"><%= stats.completedCourses %></div>
            </div>
          </div>
          <div class="stats-grid" style="margin-top: 20px;">
            <div class="stat-box">
              <div class="stat-label">Tổng giờ học</div>
              <div class="stat-value"><%= String.format("%.1f", stats.totalHours) %></div>
            </div>
            <div class="stat-box">
              <div class="stat-label">Xếp hạng</div>
              <div class="stat-value"><%= stats.totalCourses > 0 ? "Học viên tích cực" : "Mới bắt đầu" %></div>
            </div>
          </div>
          <div class="chart-section">
            <h3>Thống kê số giờ học</h3>
            <div class="chart-placeholder">
              <% if (stats.totalCourses > 0) { %>
                <p>Bạn đã học <%= String.format("%.1f", stats.totalHours) %> giờ và hoàn thành <%= stats.completedCourses %>/<%= stats.totalCourses %> khóa học</p>
              <% } else { %>
                <p>Biểu đồ sẽ hiển thị khi bạn bắt đầu học</p>
              <% } %>
            </div>
          </div>
        </div>

        <div class="tab-panel" id="courses-tab">
          <div class="courses-table-wrapper">
            <table class="courses-table">
              <thead>
                <tr>
                  <th>Tên khóa học</th>
                  <th>Ngày mua</th>
                  <th>Giá</th>
                  <th>Trạng thái</th>
                  <th>Hành động</th>
                </tr>
              </thead>
              <tbody>
                <% if (orders.isEmpty()) { %>
                  <tr>
                    <td colspan="5" class="empty-message">Bạn chưa đăng ký khóa học nào</td>
                  </tr>
                <% } else { %>
                  <% for (AccountServlet.OrderInfo order : orders) { %>
                    <tr>
                      <td><%= order.courseName %></td>
                      <td><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(order.purchaseDate) %></td>
                      <td><%= String.format("%,d", order.totalPrice.longValue()) %>₫</td>
                      <td>
                        <% if ("completed".equals(order.orderStatus)) { %>
                          <span style="color: #28a745;">✓ Đã thanh toán</span>
                        <% } else if ("rejected".equals(order.orderStatus)) { %>
                          <span style="color: #dc3545;">✗ Lỗi thanh toán</span>
                        <% } else if ("pending_payment".equals(order.orderStatus)) { %>
                          <span style="color: #ffc107;">⏳ Đang chờ duyệt</span>
                        <% } else { %>
                          <span style="color: #ffc107;">⏳ Đang xử lý</span>
                        <% } %>
                      </td>
                      <td>
                        <% if ("completed".equals(order.orderStatus)) { %>
                          <a href="${pageContext.request.contextPath}/learning.jsp?course=<%= order.courseId %>" class="btn-learn-course">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                              <path d="M8 5v14l11-7z" fill="currentColor"/>
                            </svg>
                            Vào học
                          </a>
                        <% } else if ("rejected".equals(order.orderStatus)) { %>
                          <span style="color: #dc3545;">Đơn hàng bị từ chối</span>
                        <% } else if ("pending_payment".equals(order.orderStatus)) { %>
                          <span style="color: #ffc107;">Đang chờ admin duyệt</span>
                        <% } else { %>
                          <span style="color: #999;">Chưa thanh toán</span>
                        <% } %>
                      </td>
                    </tr>
                  <% } %>
                <% } %>
              </tbody>
            </table>
          </div>
        </div>

        <div class="tab-panel" id="info-tab">
          <h2>Thông tin cá nhân</h2>
          <form class="account-form" id="infoForm">
            <div class="form-row">
              <label class="field">
                <span>Họ và tên *</span>
                <input type="text" name="fullname" value="<%= userFullname != null ? userFullname : "" %>" required />
              </label>
            </div>
            <div class="form-row">
              <label class="field">
                <span>Email *</span>
                <input type="email" name="email" value="<%= userEmail != null ? userEmail : "" %>" required />
              </label>
            </div>
            <div class="form-row">
              <label class="field">
                <span>Số điện thoại *</span>
                <input type="tel" name="phone" value="<%= userPhone != null ? userPhone : "" %>" required />
              </label>
            </div>
            <div class="form-row">
              <label class="field">
                <span>Địa chỉ</span>
                <input type="text" name="address" placeholder="Nhập địa chỉ của bạn" />
              </label>
            </div>
            <div class="form-actions">
              <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
              <button type="reset" class="btn btn-outline">Hủy</button>
            </div>
          </form>
        </div>

        <div class="tab-panel" id="password-tab">
          <h2>Đổi mật khẩu</h2>
          <form class="account-form" id="passwordForm">
            <div class="form-row">
              <label class="field">
                <span>Mật khẩu hiện tại *</span>
                <input type="password" name="currentPassword" autocomplete="current-password" required />
              </label>
            </div>
            <div class="form-row">
              <label class="field">
                <span>Mật khẩu mới *</span>
                <input type="password" name="newPassword" autocomplete="new-password" required />
              </label>
            </div>
            <div class="form-row">
              <label class="field">
                <span>Xác nhận mật khẩu mới *</span>
                <input type="password" name="confirmPassword" autocomplete="new-password" required />
              </label>
            </div>
            <div class="password-hints">
              <p><strong>Yêu cầu mật khẩu:</strong></p>
              <ul>
                <li>Tối thiểu 8 ký tự</li>
                <li>Ít nhất 1 chữ hoa</li>
                <li>Ít nhất 1 chữ thường</li>
                <li>Ít nhất 1 số</li>
              </ul>
            </div>
            <div class="form-actions">
              <button type="submit" class="btn btn-primary">Đổi mật khẩu</button>
              <button type="reset" class="btn btn-outline">Hủy</button>
            </div>
          </form>
        </div>
      </section>
    </div>
  </main>

  <div class="logout-section">
    <div class="container">
      <button class="btn btn-logout-full" id="logoutBtn">Đăng xuất</button>
    </div>
  </div>

  <%@ include file="/includes/footer.jsp" %>

  <script>
    // Tab switching
    document.querySelectorAll('.sidebar-nav .nav-item').forEach(item => {
      item.addEventListener('click', (e) => {
        e.preventDefault();
        document.querySelectorAll('.sidebar-nav .nav-item').forEach(n => n.classList.remove('active'));
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
        item.classList.add('active');
        document.getElementById(item.dataset.tab + '-tab')?.classList.add('active');
      });
    });

    // Logout
    document.getElementById('logoutBtn').addEventListener('click', () => {
      window.location.href = '${pageContext.request.contextPath}/logout';
    });

    // Form: Update info
    const baseUrl = '${pageContext.request.contextPath}';
    
    document.getElementById('infoForm').addEventListener('submit', (e) => {
      e.preventDefault();
      const formData = new FormData(e.target);
      
      fetch(baseUrl + '/updateProfile', {
        method: 'POST',
        body: new URLSearchParams(formData)
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          alert('✅ ' + data.message);
          // Reload page to update session data
          window.location.reload();
        } else {
          alert('❌ ' + data.message);
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('❌ Có lỗi xảy ra! Vui lòng thử lại.');
      });
    });

    // Form: Change password
    document.getElementById('passwordForm').addEventListener('submit', (e) => {
      e.preventDefault();
      const formData = new FormData(e.target);
      const newPassword = formData.get('newPassword');
      const confirmPassword = formData.get('confirmPassword');
      
      if(newPassword !== confirmPassword) {
        alert('❌ Mật khẩu xác nhận không khớp!');
        return;
      }
      
      if(newPassword.length < 8) {
        alert('❌ Mật khẩu phải có ít nhất 8 ký tự!');
        return;
      }
      
      fetch(baseUrl + '/changePassword', {
        method: 'POST',
        body: new URLSearchParams(formData)
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          alert('✅ ' + data.message);
          e.target.reset();
        } else {
          alert('❌ ' + data.message);
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('❌ Có lỗi xảy ra! Vui lòng thử lại.');
      });
    });
  </script>

  <style>
    .btn-learn-course {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 8px 16px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      text-decoration: none;
      border-radius: 6px;
      font-size: 14px;
      font-weight: 600;
      transition: all 0.3s ease;
      box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
    }
    .btn-learn-course:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
    }
    .btn-learn-course svg {
      width: 16px;
      height: 16px;
    }
  </style>

  <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
</body>
</html>
