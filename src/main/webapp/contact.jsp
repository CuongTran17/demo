<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
    String userEmail = (String) session.getAttribute("userEmail");
    String userPhone = (String) session.getAttribute("userPhone");
    String userFullname = (String) session.getAttribute("userFullname");
    
    String displayInfo = "";
    if (loggedIn != null && loggedIn) {
        if (userPhone != null && userPhone.length() >= 3) {
            displayInfo = "***" + userPhone.substring(userPhone.length() - 3);
        } else if (userEmail != null) {
            displayInfo = userEmail;
        }
    }
%>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <title>Liên hệ - PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
</head>
<body>
  <%@ include file="/includes/header.jsp" %>

  <main class="container contact-page">
    <div class="contact-header">
      <h1>Liên hệ với chúng tôi</h1>
      <p class="contact-subtitle">Chúng tôi luôn sẵn sàng lắng nghe và hỗ trợ bạn</p>
    </div>

    <div class="contact-layout">
      <!-- Contact Information -->
      <aside class="contact-info">
        <div class="contact-card">
          <div class="contact-icon phone-icon">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div class="contact-details">
            <h3>Số điện thoại</h3>
            <p>Hotline: <a href="tel:0123456789">0123 456 789</a></p>
            <p>Hỗ trợ: <a href="tel:0987654321">0987 654 321</a></p>
          </div>
        </div>

        <div class="contact-card">
          <div class="contact-icon email-icon">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M22 6l-10 7L2 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div class="contact-details">
            <h3>Email</h3>
            <p><a href="mailto:contact@ptitlearning.edu.vn">contact@ptitlearning.edu.vn</a></p>
            <p><a href="mailto:support@ptitlearning.edu.vn">support@ptitlearning.edu.vn</a></p>
          </div>
        </div>

        <div class="contact-card">
          <div class="contact-icon location-icon">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <circle cx="12" cy="10" r="3" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div class="contact-details">
            <h3>Địa chỉ</h3>
            <p>Học viện Công nghệ Bưu chính Viễn thông</p>
            <p>Km 10, Đường Nguyễn Trãi, Q. Hà Đông, Hà Nội</p>
          </div>
        </div>

        <div class="contact-card">
          <div class="contact-icon time-icon">
            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M12 6v6l4 2" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </div>
          <div class="contact-details">
            <h3>Giờ làm việc</h3>
            <p>Thứ 2 - Thứ 6: 8:00 - 17:30</p>
            <p>Thứ 7: 8:00 - 12:00</p>
            <p class="muted">Chủ nhật nghỉ</p>
          </div>
        </div>
      </aside>

      <!-- Feedback Form -->
      <div class="contact-form-wrapper">
        <h2>Gửi góp ý cho chúng tôi</h2>
        <p class="form-description">Mọi ý kiến đóng góp của bạn đều rất quan trọng với chúng tôi</p>
        
        <form class="contact-form" id="feedbackForm" method="post" action="${pageContext.request.contextPath}/contact">
          <div class="form-row">
            <div class="form-group">
              <label for="fullname">Họ và tên <span class="required">*</span></label>
              <input type="text" id="fullname" name="fullname" required 
                     value="<%= (userFullname != null) ? userFullname : "" %>"
                     placeholder="Nguyễn Văn A">
            </div>
            
            <div class="form-group">
              <label for="email">Email <span class="required">*</span></label>
              <input type="email" id="email" name="email" required 
                     value="<%= (userEmail != null) ? userEmail : "" %>"
                     placeholder="example@email.com">
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="phone">Số điện thoại <span class="required">*</span></label>
              <input type="tel" id="phone" name="phone" required 
                     value="<%= (userPhone != null) ? userPhone : "" %>"
                     placeholder="0123456789">
            </div>
            
            <div class="form-group">
              <label for="subject">Chủ đề</label>
              <select id="subject" name="subject">
                <option value="">-- Chọn chủ đề --</option>
                <option value="course">Khóa học</option>
                <option value="technical">Vấn đề kỹ thuật</option>
                <option value="payment">Thanh toán</option>
                <option value="suggestion">Góp ý</option>
                <option value="other">Khác</option>
              </select>
            </div>
          </div>

          <div class="form-group">
            <label for="message">Nội dung <span class="required">*</span></label>
            <textarea id="message" name="message" rows="6" required 
                      placeholder="Nhập nội dung góp ý của bạn..."></textarea>
          </div>

          <button type="submit" class="btn btn-primary btn-lg">
            <span>Gửi góp ý</span>
            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
              <path d="M22 2L11 13M22 2l-7 20-4-9-9-4 20-7z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </button>
        </form>
      </div>
    </div>
  </main>

  <%@ include file="/includes/footer.jsp" %>

  <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
  <script>
    // Form submission (specific to contact page)
    const form = document.getElementById('feedbackForm');
    if (form) {
      form.addEventListener('submit', (e) => {
        e.preventDefault();
        
        // Validate form
        const fullname = document.getElementById('fullname').value.trim();
        const email = document.getElementById('email').value.trim();
        const phone = document.getElementById('phone').value.trim();
        const message = document.getElementById('message').value.trim();

        if (!fullname || !email || !phone || !message) {
          alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
          return;
        }

        // Simulate form submission
        alert('Cảm ơn bạn đã gửi góp ý! Chúng tôi sẽ phản hồi sớm nhất có thể.');
        form.reset();
      });
    }
  </script>
</body>
</html>
