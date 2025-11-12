<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <title>Quên mật khẩu – PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
</head>
<body class="auth">
  <%@ include file="/includes/header.jsp" %>

  <main class="container auth-grid">
    <section class="auth-card">
      <h1 class="auth-title">Quên mật khẩu?</h1>
      <p class="auth-sub">Đừng lo! Nhập email hoặc số điện thoại của bạn, chúng tôi sẽ gửi link đặt lại mật khẩu.</p>

      <div id="forgot-form">
        <form class="auth-form" id="resetForm">
          <label class="field">
            <span>Email hoặc Số điện thoại *</span>
            <input type="text" id="contact" name="contact" placeholder="example@ptit.edu.vn hoặc 0123456789" required />
          </label>

          <div class="btn-row">
            <button class="btn btn-primary btn-lg" type="submit">Gửi link đặt lại</button>
            <a class="btn btn-outline btn-lg" href="${pageContext.request.contextPath}/login.jsp">Quay lại đăng nhập</a>
          </div>
        </form>
      </div>

      <div id="success-msg" style="display: none;">
        <div style="background: #e6ffe6; border: 1px solid #00cc00; color: #006600; padding: 20px; border-radius: 12px; text-align: center;">
          <h3 style="margin: 0 0 12px; font-size: 24px;">✅ Thành công!</h3>
          <p style="margin: 0; line-height: 1.6;">
            Chúng tôi đã gửi link đặt lại mật khẩu đến <strong id="sent-to"></strong>.<br/>
            Vui lòng kiểm tra email/tin nhắn và làm theo hướng dẫn.
          </p>
          <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary" style="margin-top: 20px; display: inline-flex;">Quay lại đăng nhập</a>
        </div>
      </div>
    </section>

    <aside class="auth-aside">
      <h2 class="promo-title">HƯỚNG DẪN LẤY LẠI MẬT KHẨU</h2>
      <div class="promo-features">
        <h3>Các bước thực hiện:</h3>
        <ul>
          <li>📧 <strong>Bước 1:</strong> Nhập email hoặc số điện thoại đã đăng ký</li>
          <li>📬 <strong>Bước 2:</strong> Kiểm tra hộp thư email/tin nhắn SMS</li>
          <li>🔗 <strong>Bước 3:</strong> Nhấp vào link trong email/SMS</li>
          <li>🔐 <strong>Bước 4:</strong> Tạo mật khẩu mới</li>
          <li>✅ <strong>Bước 5:</strong> Đăng nhập với mật khẩu mới</li>
        </ul>
      </div>
      <div style="margin-top: 24px; padding: 16px; background: #fff3cd; border: 1px solid #ffc107; border-radius: 8px;">
        <p style="margin: 0; font-size: 14px; color: #856404;">
          <strong>⚠️ Lưu ý:</strong> Link đặt lại mật khẩu chỉ có hiệu lực trong 24 giờ. Nếu không nhận được email/SMS, vui lòng kiểm tra thư mục spam hoặc thử lại.
        </p>
      </div>
    </aside>
  </main>

  <script>
    const btn = document.getElementById('hamburger');
    const menu = document.querySelector('.menu');
    if(btn && menu){
      btn.addEventListener('click', () => {
        const open = btn.getAttribute('aria-expanded') === 'true';
        btn.setAttribute('aria-expanded', String(!open));
        menu.classList.toggle('open');
      });
    }

    const ddTrigger = document.querySelector('.menu .has-dd');
    const ddParent = ddTrigger ? ddTrigger.closest('.dropdown') : null;
    if(ddTrigger && ddParent){
      ddTrigger.addEventListener('click', (e)=>{
        if(window.matchMedia('(max-width: 900px)').matches){
          e.preventDefault();
          ddParent.classList.toggle('open');
          const expanded = ddTrigger.getAttribute('aria-expanded') === 'true';
          ddTrigger.setAttribute('aria-expanded', String(!expanded));
        }
      });
    }

    // Handle form submission (demo only - no backend)
    document.getElementById('resetForm').addEventListener('submit', function(e) {
      e.preventDefault();
      
      const contact = document.getElementById('contact').value.trim();
      
      if (!contact) {
        alert('Vui lòng nhập email hoặc số điện thoại!');
        return;
      }

      // Validate email or phone format
      const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      const phonePattern = /^[0-9]{10,11}$/;
      
      if (!emailPattern.test(contact) && !phonePattern.test(contact)) {
        alert('Email hoặc số điện thoại không hợp lệ!');
        return;
      }

      // Simulate sending reset link
      setTimeout(function() {
        document.getElementById('forgot-form').style.display = 'none';
        document.getElementById('success-msg').style.display = 'block';
        
        // Display masked contact info
        let displayContact = contact;
        if (emailPattern.test(contact)) {
          // Mask email: ex***@ptit.edu.vn
          const parts = contact.split('@');
          const username = parts[0];
          const domain = parts[1];
          displayContact = username.substring(0, 2) + '***@' + domain;
        } else {
          // Mask phone: ***6789
          displayContact = '***' + contact.substring(contact.length - 4);
        }
        
        document.getElementById('sent-to').textContent = displayContact;
      }, 500);
    });
  </script>

  <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
</body>
</html>
