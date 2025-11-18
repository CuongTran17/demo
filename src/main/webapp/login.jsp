<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <title>Đăng nhập – PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
</head>
<body class="auth">
  <%@ include file="/includes/header.jsp" %>

  <main class="container auth-grid">
    <!-- Left: Form -->
    <section class="auth-card">
      <h1 class="auth-title">Chào mừng trở lại</h1>
      <p class="auth-sub">Vui lòng nhập thông tin của bạn để bắt đầu ngay!</p>

      <% 
        String error = (String) request.getAttribute("error");
        if (error != null && !error.isEmpty()) {
      %>
        <div class="error-msg">❌ <%= error %></div>
      <% } %>

      <form class="auth-form" method="post" action="${pageContext.request.contextPath}/login">
        <label class="field">
          <span>Email/SĐT</span>
          <input type="text" name="username" value="<%= request.getAttribute("emailOrPhone") != null ? request.getAttribute("emailOrPhone") : "" %>" autocomplete="username" required />
        </label>
        <label class="field">
          <span>Mật khẩu</span>
          <input type="password" name="password" autocomplete="current-password" required />
        </label>

        <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 8px;">
          <label style="display: flex; align-items: center; gap: 8px; cursor: pointer;">
            <input type="checkbox" name="rememberMe" value="true" style="width: auto; cursor: pointer;" />
            <span style="font-size: 14px; color: #333;">Ghi nhớ đăng nhập</span>
          </label>
          <a href="${pageContext.request.contextPath}/forgot-password.jsp" style="color: #007bff; font-size: 14px; text-decoration: none;">Quên mật khẩu?</a>
        </div>

        <div class="btn-row">
          <button class="btn btn-primary btn-lg" type="submit">Bước tiếp theo</button>
          <a class="btn btn-outline btn-lg" href="${pageContext.request.contextPath}/signup.jsp">Tạo tài khoản</a>
          <a class="btn btn-ghost btn-lg" href="${pageContext.request.contextPath}/">Thoát</a>
        </div>
      </form>
    </section>

    <!-- Right: Promo -->
    <aside class="auth-aside">
      <h2 class="promo-title">HỌC VỚI GIÁ TRỊ TUYỆT VỜI</h2>
      <p class="promo-sub">Tiết kiệm đến 70% với gói combo giảm giá của chúng tôi so với việc mua từng khóa học riêng lẻ. Tham gia ngay!</p>
      <figure class="promo-media">
        <img src="${pageContext.request.contextPath}/assets/img/auth/login-promo.png" alt="Ưu đãi học tập" />
      </figure>
      <div class="promo-features">
        <h3>Tài khoản mẫu để thử:</h3>
        <ul>
          <li>📧 Email: <strong>user1@ptit.edu.vn</strong></li>
          <li>📱 Hoặc SĐT: <strong>0123456789</strong></li>
          <li>🔑 Mật khẩu: <strong>123456</strong></li>
        </ul>
        <p style="margin-top:12px;font-size:13px;color:#666">Hoặc user2@ptit.edu.vn / 0987654321 - mật khẩu: 123456</p>
      </div>
    </aside>
  </main>

  <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
</body>
</html>
