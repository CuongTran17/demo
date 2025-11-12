<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.model.Course" %>
<%@ page import="java.math.BigDecimal" %>
<%
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
    String userEmail = (String) session.getAttribute("userEmail");
    String userPhone = (String) session.getAttribute("userPhone");
    String userFullname = (String) session.getAttribute("userFullname");
    Integer userId = (Integer) session.getAttribute("userId");
    
    // Kiểm tra đăng nhập - redirect nếu chưa đăng nhập
    if (loggedIn == null || !loggedIn) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=checkout");
        return;
    }
    
    String displayInfo = "";
    if (userPhone != null && userPhone.length() >= 3) {
        displayInfo = "***" + userPhone.substring(userPhone.length() - 3);
    } else if (userEmail != null) {
        displayInfo = userEmail;
    }
    
    // Load cart from database via DAO
    com.example.dao.CartDAO cartDAO = new com.example.dao.CartDAO();
    com.example.dao.CourseDAO courseDAO = new com.example.dao.CourseDAO();
    
    List<String> cartItems = cartDAO.getUserCart(userId);
    List<Course> cartCourses = new java.util.ArrayList<>();
    
    for (String courseId : cartItems) {
        try {
            Course course = courseDAO.getCourseById(courseId);
            if (course != null) {
                cartCourses.add(course);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
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
  <title>Thanh toán - PTIT LEARNING</title>
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
                <a href="${pageContext.request.contextPath}/courses-python.jsp">Lập trình - CNTT</a>
                <a href="${pageContext.request.contextPath}/courses-finance.jsp">Tài chính</a>
                <a href="${pageContext.request.contextPath}/courses-data.jsp">Data analyst</a>
                <a href="${pageContext.request.contextPath}/courses-blockchain.jsp">Blockchain</a>
                <a href="${pageContext.request.contextPath}/courses-accounting.jsp">Kế toán</a>
                <a href="${pageContext.request.contextPath}/courses-marketing.jsp">Marketing</a>
              </div>
            </div>
          </div>
        </div>
        <a href="${pageContext.request.contextPath}/blog.jsp">Blog</a>
        <a href="${pageContext.request.contextPath}/contact.jsp">Liên hệ</a>
        <a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a>
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

  <main class="container checkout-page">
    <h1 class="page-title">THANH TOÁN</h1>

    <div class="checkout-layout">
      <!-- Left Column: Customer Info & Payment Method -->
      <div class="checkout-left">
        <!-- Customer Info -->
        <div class="checkout-section">
          <h2 class="section-title">Thông tin khách hàng</h2>
          <div class="form-group">
            <label for="customerName">Họ và tên</label>
            <input type="text" id="customerName" value="<%= userFullname != null ? userFullname : "" %>" readonly class="form-control" />
          </div>
          <div class="form-group">
            <label for="customerPhone">Số điện thoại</label>
            <input type="text" id="customerPhone" value="<%= userPhone != null ? userPhone : "" %>" readonly class="form-control" />
          </div>
        </div>

        <!-- Payment Method -->
        <div class="checkout-section">
          <h2 class="section-title">Phương thức thanh toán</h2>
          <div class="payment-methods">
            <label class="payment-option">
              <input type="radio" name="paymentMethod" value="cod" checked />
              <div class="payment-content">
                <span class="payment-icon">💳</span>
                <div class="payment-info">
                  <strong>Thanh toán khi giao hàng (COD)</strong>
                  <p class="payment-desc">Thanh toán bằng tiền mặt khi nhận hàng</p>
                </div>
              </div>
            </label>
            <label class="payment-option">
              <input type="radio" name="paymentMethod" value="bank" />
              <div class="payment-content">
                <span class="payment-icon">🏦</span>
                <div class="payment-info">
                  <strong>Chuyển khoản qua QR - VCB</strong>
                  <p class="payment-desc">Quét mã QR để thanh toán</p>
                </div>
              </div>
            </label>
          </div>
        </div>

        <!-- Note -->
        <div class="checkout-section">
          <h2 class="section-title">Ghi chú đơn hàng</h2>
          <div class="form-group">
            <textarea id="orderNote" rows="4" placeholder="Nhập ghi chú của bạn..." class="form-control"></textarea>
          </div>
        </div>
      </div>

      <!-- Right Column: Order Summary -->
      <div class="checkout-right">
        <!-- Products -->
        <div class="checkout-section order-products">
          <h2 class="section-title">Sản phẩm</h2>
          <div id="productList" class="product-list">
            <% if (cartCourses.isEmpty()) { %>
              <p class="empty-message">Giỏ hàng trống</p>
            <% } else { %>
              <% for (Course course : cartCourses) { %>
                <div class="product-item">
                  <div class="product-name"><%= course.getCourseName() %></div>
                  <div class="product-price"><%= String.format("%,d", course.getPrice().longValue()) %>₫</div>
                </div>
              <% } %>
            <% } %>
          </div>
        </div>

        <!-- Discount Code -->
        <div class="checkout-section">
          <h2 class="section-title">Mã khuyến mãi</h2>
          <div class="discount-input-group">
            <input type="text" id="discountCode" placeholder="Nhập mã khuyến mãi" class="form-control" />
            <button class="btn-apply" onclick="applyDiscount()">Áp dụng</button>
          </div>
        </div>

        <!-- Order Summary -->
        <div class="checkout-section order-summary">
          <h2 class="section-title">Tóm tắt đơn hàng</h2>
          <div class="summary-row">
            <span>Tổng tiền hàng</span>
            <strong id="subtotal"><%= String.format("%,d", total.longValue()) %>₫</strong>
          </div>
          <div class="summary-row">
            <span>Phí vận chuyển</span>
            <strong id="shipping">Miễn phí</strong>
          </div>
          <div class="summary-row discount-row" id="discountRow" style="display: none;">
            <span>Giảm giá</span>
            <strong id="discountAmount" class="discount-amount">-0₫</strong>
          </div>
          <div class="summary-divider"></div>
          <div class="summary-row total-row">
            <span>Tổng thanh toán</span>
            <strong id="totalAmount" class="total-amount"><%= String.format("%,d", total.longValue()) %>₫</strong>
          </div>
          <input type="hidden" id="originalTotal" value="<%= total.longValue() %>" />
          <button class="btn-checkout" onclick="placeOrder()">Đặt hàng</button>
          <a href="${pageContext.request.contextPath}/cart" class="back-to-cart">← Quay lại giỏ hàng</a>
        </div>
      </div>
    </div>
  </main>

  <%@ include file="/includes/footer.jsp" %>

  <script>
    // Hamburger menu
    const btn = document.getElementById('hamburger');
    const menu = document.querySelector('.menu');
    if(btn && menu){
      btn.addEventListener('click', function() {
        const open = btn.getAttribute('aria-expanded') === 'true';
        btn.setAttribute('aria-expanded', String(!open));
        menu.classList.toggle('open');
      });
    }

    // Dropdown menu (click-based)
    const ddTrigger = document.querySelector('.menu .has-dd');
    const ddParent = ddTrigger ? ddTrigger.closest('.dropdown') : null;
    if(ddTrigger && ddParent){
      ddTrigger.addEventListener('click', function(e) {
        e.preventDefault();
        ddParent.classList.toggle('open');
        ddTrigger.setAttribute('aria-expanded', String(ddParent.classList.contains('open')));
      });
      
      document.addEventListener('click', function(e) {
        if (!ddParent.contains(e.target)) {
          ddParent.classList.remove('open');
          ddTrigger.setAttribute('aria-expanded', 'false');
        }
      });
    }

    // Format price helper
    function formatPrice(price) {
      return price.toLocaleString('vi-VN') + '₫';
    }

    // Apply discount
    function applyDiscount() {
      const code = document.getElementById('discountCode').value.trim();
      if (!code) {
        alert('❌ Vui lòng nhập mã khuyến mãi!');
        return;
      }

      // Mock discount codes
      const discounts = {
        'PTIT10': 0.1,
        'PTIT20': 0.2,
        'SAVE30': 0.3
      };

      if (discounts[code.toUpperCase()]) {
        const discount = discounts[code.toUpperCase()];
        const originalTotal = parseInt(document.getElementById('originalTotal').value);
        
        const discountAmount = Math.round(originalTotal * discount);
        const finalTotal = originalTotal - discountAmount;

        document.getElementById('discountRow').style.display = 'flex';
        document.getElementById('discountAmount').textContent = '-' + formatPrice(discountAmount);
        document.getElementById('totalAmount').textContent = formatPrice(finalTotal);

        alert('✅ Áp dụng mã giảm giá thành công! Giảm ' + (discount * 100) + '%');
      } else {
        alert('❌ Mã khuyến mãi không hợp lệ!');
      }
    }

    // Place order
    const baseUrl = '${pageContext.request.contextPath}';
    
    function placeOrder() {
      <% if (cartCourses.isEmpty()) { %>
        alert('❌ Giỏ hàng trống! Vui lòng thêm sản phẩm vào giỏ hàng.');
        window.location.href = baseUrl + '/';
        return;
      <% } %>

      const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
      
      // Submit order to servlet
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = baseUrl + '/checkout';
      
      const paymentInput = document.createElement('input');
      paymentInput.type = 'hidden';
      paymentInput.name = 'paymentMethod';
      paymentInput.value = paymentMethod;
      form.appendChild(paymentInput);
      
      document.body.appendChild(form);
      form.submit();
    }
  </script>
</body>
</html>
