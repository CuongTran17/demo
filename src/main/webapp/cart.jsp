<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.model.Course" %>
<%@ page import="java.math.BigDecimal" %>
<%
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
    String userEmail = (String) session.getAttribute("userEmail");
    String userPhone = (String) session.getAttribute("userPhone");
    String userFullname = (String) session.getAttribute("userFullname");
    
    // Kiểm tra đăng nhập - redirect nếu chưa đăng nhập
    if (loggedIn == null || !loggedIn) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=cart");
        return;
    }
    
    String displayInfo = "";
    if (userPhone != null && userPhone.length() >= 3) {
        displayInfo = "***" + userPhone.substring(userPhone.length() - 3);
    } else if (userEmail != null) {
        displayInfo = userEmail;
    }
    
    // Get cart courses from servlet
    @SuppressWarnings("unchecked")
    List<Course> cartCourses = (List<Course>) request.getAttribute("cartCourses");
    if (cartCourses == null) cartCourses = new java.util.ArrayList<>();
    
    // Calculate total
    BigDecimal total = BigDecimal.ZERO;
    for (Course course : cartCourses) {
        total = total.add(course.getPrice());
    }
%>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <title>Giỏ hàng - PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
</head>
<body>
  <header class="topbar">
    <div class="container nav">
      <a class="brand" href="${pageContext.request.contextPath}/">PTIT <strong>LEARNING</strong> <span class="by">by FIN1</span></a>
      <nav class="menu" aria-label="Chính">
        <div class="dropdown">
          <a href="${pageContext.request.contextPath}/#courses" class="has-dd" id="coursesMenu" aria-haspopup="true" aria-expanded="false">Các khóa học</a>
          <div class="dd" role="menu" aria-labelledby="coursesMenu">
            <div class="dd-inner">
              <div class="dd-head">Tất cả các khóa học</div>
              <div class="dd-grid">
                <a href="${pageContext.request.contextPath}/courses?category=python">Lập trình - CNTT</a>
                <a href="${pageContext.request.contextPath}/courses?category=finance">Tài chính</a>
                <a href="${pageContext.request.contextPath}/courses?category=data">Data analyst</a>
                <a href="${pageContext.request.contextPath}/courses?category=blockchain">Blockchain</a>
                <a href="${pageContext.request.contextPath}/courses?category=accounting">Kế toán</a>
                <a href="${pageContext.request.contextPath}/courses?category=marketing">Marketing</a>
              </div>
            </div>
          </div>
        </div>
        <a href="${pageContext.request.contextPath}/blog.jsp">Blog</a>
        <a href="${pageContext.request.contextPath}/contact.jsp">Liên hệ</a>
        <a href="${pageContext.request.contextPath}/cart" class="active">Giỏ hàng</a>
        <% if (loggedIn != null && loggedIn) { %>
          <a href="${pageContext.request.contextPath}/account" class="user-info"><%= displayInfo %></a>
        <% } else { %>
          <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-sm">Đăng nhập</a>
        <% } %>
      </nav>
      <button class="hamburger" id="hamburger" aria-label="Mở menu" aria-expanded="false">
        <span></span><span></span><span></span>
      </button>
    </div>
  </header>

  <main class="container cart-page">
    <h1 class="page-title">GIỎ HÀNG</h1>

    <div class="cart-content">
      <div class="cart-table-wrapper">
        <table class="cart-table">
          <thead>
            <tr>
              <th>Tên sản phẩm</th>
              <th>Giá tiền</th>
              <th></th>
            </tr>
          </thead>
          <tbody id="cartItems">
            <% if (cartCourses.isEmpty()) { %>
              <tr class="empty-cart">
                <td colspan="3" class="empty-message">
                  <div style="padding: 40px; text-align: center;">
                    <div style="font-size: 48px; margin-bottom: 16px;">🛒</div>
                    <div style="font-size: 18px; color: #666; margin-bottom: 8px;">Giỏ hàng trống</div>
                    <div style="font-size: 14px; color: #999;">Hãy thêm khóa học vào giỏ hàng để bắt đầu học!</div>
                  </div>
                </td>
              </tr>
            <% } else { %>
              <% for (Course course : cartCourses) { %>
                <tr>
                  <td>
                    <div class="cart-item-name"><%= course.getCourseName() %></div>
                  </td>
                  <td>
                    <strong><%= String.format("%,d", course.getPrice().longValue()) %>₫</strong>
                  </td>
                  <td>
                    <button class="btn-remove" onclick="removeItem('<%= course.getCourseId() %>')" title="Xóa">
                      Xóa
                    </button>
                  </td>
                </tr>
              <% } %>
            <% } %>
          </tbody>
        </table>
      </div>

      <div class="cart-summary">
        <div class="summary-row">
          <span>Tổng cộng:</span>
          <strong id="totalAmount"><%= String.format("%,d", total.longValue()) %>₫</strong>
        </div>
        <div class="cart-note">
          <label for="noteInput">Ghi chú</label>
          <textarea id="noteInput" rows="3" placeholder="Nhập ghi chú của bạn..."></textarea>
        </div>
        <div class="cart-actions">
          <button class="btn btn-update" onclick="updateCart()">Cập nhật</button>
          <button class="btn btn-checkout" onclick="checkout()">Thanh toán</button>
        </div>
        <a href="${pageContext.request.contextPath}/" class="continue-shopping">&#8592; Tiếp tục mua hàng</a>
      </div>
    </div>
  </main>

  <%@ include file="/includes/footer.jsp" %>

  <script>
    // Hamburger menu
    const btn = document.getElementById('hamburger');
    const menu = document.querySelector('.menu');
    if(btn && menu){
      btn.addEventListener('click', () => {
        const open = btn.getAttribute('aria-expanded') === 'true';
        btn.setAttribute('aria-expanded', String(!open));
        menu.classList.toggle('open');
      });
    }

    // Dropdown menu (click-based)
    const ddTrigger = document.querySelector('.menu .has-dd');
    const ddParent = ddTrigger?.closest('.dropdown');
    if(ddTrigger && ddParent){
      ddTrigger.addEventListener('click', (e) => {
        e.preventDefault();
        ddParent.classList.toggle('open');
        ddTrigger.setAttribute('aria-expanded', String(ddParent.classList.contains('open')));
      });
      
      document.addEventListener('click', (e) => {
        if (!ddParent.contains(e.target)) {
          ddParent.classList.remove('open');
          ddTrigger.setAttribute('aria-expanded', 'false');
        }
      });
    }

    // Cart functions
    const baseUrl = '${pageContext.request.contextPath}';
    
    function removeItem(courseId) {
      if (!confirm('Bạn có chắc muốn xóa khóa học này?')) return;
      
      fetch(baseUrl + '/cart', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'action=remove&courseId=' + encodeURIComponent(courseId)
      })
      .then(() => {
        window.location.reload();
      })
      .catch(error => {
        console.error('Error:', error);
        alert('❌ Có lỗi xảy ra! Vui lòng thử lại.');
      });
    }

    function updateCart() {
      alert('✅ Giỏ hàng đã được cập nhật!');
    }

    function checkout() {
      <% if (cartCourses.isEmpty()) { %>
        alert('❌ Giỏ hàng trống! Vui lòng thêm khóa học vào giỏ hàng.');
        return;
      <% } %>
      // Redirect to checkout page
      window.location.href = baseUrl + '/checkout.jsp';
    }
  </script>
</body>
</html>
