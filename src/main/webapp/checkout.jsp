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
              <input type="radio" name="paymentMethod" value="credit_card" checked />
              <div class="payment-content">
                <span class="payment-icon">💳</span>
                <div class="payment-info">
                  <strong>Thanh toán thẻ tín dụng (Trả góp 0%)</strong>
                  <p class="payment-desc">Thanh toán bằng thẻ tín dụng, hỗ trợ trả góp lãi suất 0%</p>
                </div>
              </div>
            </label>
            <label class="payment-option">
              <input type="radio" name="paymentMethod" value="vietqr" />
              <div class="payment-content">
                <span class="payment-icon">📱</span>
                <div class="payment-info">
                  <strong>Chuyển khoản QR VietQR</strong>
                  <p class="payment-desc">Quét mã QR để thanh toán ngay</p>
                </div>
              </div>
            </label>
          </div>
          
          <!-- QR Code Display Area -->
          <div id="qrCodeSection" style="display: none; margin-top: 20px; padding: 20px; background: #f8f9fa; border-radius: 8px; text-align: center;">
            <h3 style="margin-bottom: 15px; color: #667eea;">Quét mã QR để thanh toán</h3>
            <div id="qrCodeContainer" style="display: inline-block; padding: 15px; background: white; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
              <img id="qrCodeImage" src="" alt="QR Code" style="max-width: 300px; width: 100%;" />
            </div>
            <div style="margin-top: 15px;">
              <p style="margin: 5px 0;"><strong>Ngân hàng:</strong> TPBank</p>
              <p style="margin: 5px 0;"><strong>Số tài khoản:</strong> 03942487601</p>
              <p style="margin: 5px 0;"><strong>Chủ tài khoản:</strong> TRAN DUC CUONG</p>
              <p style="margin: 5px 0; color: #e53e3e;"><strong>Số tiền:</strong> <span id="qrAmount"></span></p>
              <p style="margin: 5px 0; font-size: 0.9em; color: #666;">Nội dung: <span id="qrNote"></span></p>
            </div>
            <div style="margin-top: 15px; padding: 12px; background: #fff3cd; border-radius: 6px; border-left: 4px solid #ffc107;">
              <p style="margin: 0; color: #856404; font-size: 0.95em;">
                ⚠️ Sau khi chuyển khoản, đơn hàng sẽ được gửi tới Admin để duyệt. Bạn sẽ có quyền truy cập khóa học sau khi Admin duyệt đơn hàng.
              </p>
            </div>
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
    // Base URL for AJAX requests
    const baseUrl = '';
    console.log('baseUrl defined:', baseUrl, 'timestamp:', Date.now());
    
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

    const totalAmount = <%= total != null ? total.longValue() : 0 %>;
    
    // Payment method change handler
    document.querySelectorAll('input[name="paymentMethod"]').forEach(radio => {
      radio.addEventListener('change', function() {
        const qrSection = document.getElementById('qrCodeSection');
        if (this.value === 'vietqr') {
          // Generate QR code using VietQR API
          generateVietQR();
          qrSection.style.display = 'block';
        } else {
          qrSection.style.display = 'none';
        }
      });
    });
    
    // Generate VietQR code
    function generateVietQR() {
      // Get current total (after discount if any)
      const totalText = document.getElementById('totalAmount').textContent;
      const amount = parseInt(totalText.replace(/[^\d]/g, ''));
      
      // Generate unique order note
      const orderNote = 'PTIT' + Date.now().toString().slice(-8);
      
      // VietQR API parameters
      const BANK_ID = '970423'; // TPBank
      const ACCOUNT_NO = '03942487601';
      const ACCOUNT_NAME = 'TRAN DUC CUONG';
      const TEMPLATE = 'compact'; // or 'compact2', 'qr_only'
      
      // Build VietQR API URL using JavaScript concatenation
      const qrUrl = 'https://img.vietqr.io/image/' + BANK_ID + '-' + ACCOUNT_NO + '-' + TEMPLATE + '.png?amount=' + amount + '&addInfo=' + encodeURIComponent(orderNote) + '&accountName=' + encodeURIComponent(ACCOUNT_NAME);
      
      // Display QR code
      document.getElementById('qrCodeImage').src = qrUrl;
      document.getElementById('qrAmount').textContent = formatPrice(amount);
      document.getElementById('qrNote').textContent = orderNote;
      
      // Store order note for submission
      document.getElementById('orderNote').value = orderNote;
    }
    
    function placeOrder() {
      const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked').value;
      
      // Show confirmation
      let confirmMsg = 'Xác nhận đặt hàng?\n\n';
      if (paymentMethod === 'vietqr') {
        confirmMsg += '⚠️ Vui lòng chuyển khoản theo mã QR.\n';
        confirmMsg += 'Đơn hàng sẽ được gửi tới Admin để duyệt.\n';
        confirmMsg += 'Bạn sẽ nhận được quyền truy cập sau khi Admin duyệt.';
      } else {
        confirmMsg += 'Đơn hàng sẽ được gửi tới Admin để duyệt.\n';
        confirmMsg += 'Bạn sẽ nhận được quyền truy cập sau khi Admin duyệt.';
      }
      
      const confirmed = confirm(confirmMsg);
      if (!confirmed) {
        return;
      }
      
      // Submit order to servlet
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = baseUrl + '/checkout';
      
      const paymentInput = document.createElement('input');
      paymentInput.type = 'hidden';
      paymentInput.name = 'paymentMethod';
      paymentInput.value = paymentMethod;
      form.appendChild(paymentInput);
      
      const noteInput = document.createElement('input');
      noteInput.type = 'hidden';
      noteInput.name = 'orderNote';
      noteInput.value = document.getElementById('orderNote').value;
      form.appendChild(noteInput);
      
      document.body.appendChild(form);
      form.submit();
    }
  </script>
</body>
</html>
