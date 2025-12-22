<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <title>Đăng ký – PTIT LEARNING</title>
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
      <h1 class="auth-title">Tạo tài khoản mới</h1>
      <p class="auth-sub">Điền thông tin để bắt đầu hành trình học tập của bạn!</p>

      <% String error = (String) request.getAttribute("error"); %>
      <% if (error != null) { %>
        <div class="alert alert-danger" role="alert">
          <strong>⚠️ Lỗi:</strong> <%= error %>
        </div>
      <% } %>

      <form class="auth-form" id="signupForm" method="post" action="${pageContext.request.contextPath}/signup" novalidate>
        <label class="field">
          <span>Họ và tên *</span>
          <input type="text" name="fullname" id="fullname" value="<%= request.getAttribute("fullname") != null ? request.getAttribute("fullname") : "" %>" required />
          <small class="field-error"></small>
        </label>
        <label class="field">
          <span>Email *</span>
          <input type="email" name="email" id="email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" autocomplete="email" required />
          <small class="field-error"></small>
        </label>
        <label class="field">
          <span>Số điện thoại *</span>
          <input type="tel" name="phone" id="phone" value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" pattern="[0-9]{10}" placeholder="0123456789" required />
          <small class="field-error"></small>
        </label>
        <label class="field">
          <span>Mật khẩu *</span>
          <input type="password" name="password" id="password" autocomplete="new-password" minlength="8" required />
          <small class="field-error"></small>
          <small class="field-hint">Tối thiểu 8 ký tự, bao gồm chữ hoa, chữ thường và số</small>
        </label>
        <label class="field">
          <span>Xác nhận mật khẩu *</span>
          <input type="password" name="confirmPassword" id="confirmPassword" autocomplete="new-password" minlength="8" required />
          <small class="field-error"></small>
        </label>

        <div class="btn-row">
          <button class="btn btn-primary btn-lg" type="submit">Đăng ký ngay</button>
          <a class="btn btn-outline btn-lg" href="${pageContext.request.contextPath}/login.jsp">Đã có tài khoản?</a>
          <a class="btn btn-ghost btn-lg" href="${pageContext.request.contextPath}/">Thoát</a>
        </div>
      </form>
    </section>

    <!-- Right: Promo -->
    <aside class="auth-aside">
      <h2 class="promo-title">THAM GIA CÙNG CHÚNG TÔI</h2>
      <p class="promo-sub">Hơn 10,000+ sinh viên đã tin tưởng và học tập cùng PTIT LEARNING. Trở thành một phần của cộng đồng ngay hôm nay!</p>
      <figure class="promo-media">
        <img src="${pageContext.request.contextPath}/assets/img/auth/signup-promo.png" alt="Tham gia học tập" />
      </figure>
      <div class="promo-features">
        <h3>Lợi ích khi đăng ký:</h3>
        <ul>
          <li>✓ Truy cập miễn phí các khóa học demo</li>
          <li>✓ Nhận thông báo về các ưu đãi mới</li>
          <li>✓ Tham gia cộng đồng học tập</li>
          <li>✓ Theo dõi tiến độ học tập</li>
        </ul>
      </div>
    </aside>
  </main>

  <!-- Modal for error notification -->
  <div id="errorModal" class="modal">
    <div class="modal-content error-modal">
      <div class="modal-icon">⚠️</div>
      <h2 class="modal-title">Đăng ký không thành công</h2>
      <p class="modal-message" id="errorModalMessage"></p>
      <button class="btn btn-primary" onclick="closeErrorModal()">Đã hiểu</button>
    </div>
  </div>

  <script>
    const btn = document.getElementById('hamburger');
    const menu = document.querySelector('.menu');
    if(btn && menu){
      btn.addEventListener('click',()=>{
        const open = btn.getAttribute('aria-expanded') === 'true';
        btn.setAttribute('aria-expanded', String(!open));
        menu.classList.toggle('open');
      });
    }
    // Dropdown toggle for mobile
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

    function showErrorModal(message) {
      const modal = document.getElementById('errorModal');
      const messageEl = document.getElementById('errorModalMessage');
      messageEl.textContent = message;
      modal.style.display = 'flex';
    }

    function closeErrorModal() {
      const modal = document.getElementById('errorModal');
      modal.style.display = 'none';
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
      const modal = document.getElementById('errorModal');
      if (event.target === modal) {
        closeErrorModal();
      }
    }

    // ===== FORM VALIDATION =====
    const form = document.getElementById('signupForm');
    const fields = {
      fullname: document.getElementById('fullname'),
      email: document.getElementById('email'),
      phone: document.getElementById('phone'),
      password: document.getElementById('password'),
      confirmPassword: document.getElementById('confirmPassword')
    };

    let emailCheckTimeout;
    let emailExists = false;
    let isCheckingEmail = false;

    // Validation rules
    const validators = {
      fullname: (value) => {
        if (!value.trim()) return 'Vui lòng nhập họ tên';
        if (value.trim().length < 3) return 'Họ tên phải có ít nhất 3 ký tự';
        return '';
      },
      email: (value) => {
        if (!value.trim()) return 'Vui lòng nhập email';
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(value)) return 'Email không hợp lệ';
        if (emailExists) return 'Email đã tồn tại';
        return '';
      },
      phone: (value) => {
        if (!value.trim()) return 'Vui lòng nhập số điện thoại';
        if (!/^[0-9]{10}$/.test(value)) return 'Số điện thoại phải có 10 chữ số';
        return '';
      },
      password: (value) => {
        if (!value) return 'Vui lòng nhập mật khẩu';
        if (value.length < 8) return 'Mật khẩu phải có ít nhất 8 ký tự';
        if (!/[A-Z]/.test(value)) return 'Mật khẩu phải có ít nhất 1 chữ hoa';
        if (!/[a-z]/.test(value)) return 'Mật khẩu phải có ít nhất 1 chữ thường';
        if (!/[0-9]/.test(value)) return 'Mật khẩu phải có ít nhất 1 chữ số';
        return '';
      },
      confirmPassword: (value) => {
        if (!value) return 'Vui lòng xác nhận mật khẩu';
        if (value !== fields.password.value) return 'Mật khẩu xác nhận không khớp';
        return '';
      }
    };

    // Check email exists via AJAX
    function checkEmailExists(email) {
      if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        emailExists = false;
        return;
      }

      isCheckingEmail = true;
      fetch('${pageContext.request.contextPath}/api/check-email?email=' + encodeURIComponent(email))
        .then(response => response.json())
        .then(data => {
          emailExists = data.exists;
          isCheckingEmail = false;
          // Re-validate to update UI
          validateField('email');
        })
        .catch(error => {
          console.error('Error checking email:', error);
          emailExists = false;
          isCheckingEmail = false;
        });
    }

    // Show error/success
    function setFieldState(field, error) {
      const fieldLabel = field.closest('.field');
      const errorEl = fieldLabel.querySelector('.field-error');
      
      if (error) {
        fieldLabel.classList.add('error');
        fieldLabel.classList.remove('success');
        errorEl.textContent = error;
      } else if (field.value.trim()) {
        fieldLabel.classList.remove('error');
        fieldLabel.classList.add('success');
        errorEl.textContent = '';
      } else {
        fieldLabel.classList.remove('error', 'success');
        errorEl.textContent = '';
      }
    }

    // Validate single field
    function validateField(fieldName) {
      const field = fields[fieldName];
      const error = validators[fieldName](field.value);
      setFieldState(field, error);
      return !error;
    }

    // Real-time validation
    Object.keys(fields).forEach(fieldName => {
      const field = fields[fieldName];
      
      // Validate on blur - but skip email as it has special handling
      if (fieldName !== 'email') {
        field.addEventListener('blur', () => {
          validateField(fieldName);
        });
      }
      
      // Validate on input (for password match)
      field.addEventListener('input', () => {
        if (field.closest('.field').classList.contains('error')) {
          validateField(fieldName);
        }
        // Also revalidate confirmPassword when password changes
        if (fieldName === 'password' && fields.confirmPassword.value) {
          validateField('confirmPassword');
        }
      });
    });

    // Email real-time check
    fields.email.addEventListener('input', () => {
      clearTimeout(emailCheckTimeout);
      emailExists = false; // Reset immediately when typing
      
      const emailValue = fields.email.value.trim();
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      
      // Remove success state immediately when typing
      const fieldLabel = fields.email.closest('.field');
      fieldLabel.classList.remove('success');
      
      // Only check if email format is valid
      if (emailRegex.test(emailValue)) {
        emailCheckTimeout = setTimeout(() => {
          checkEmailExists(emailValue);
        }, 500); // Debounce 500ms
      }
    });
    
    // Also check on blur
    fields.email.addEventListener('blur', () => {
      const emailValue = fields.email.value.trim();
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      
      if (emailRegex.test(emailValue)) {
        // Force immediate check on blur and wait for result
        clearTimeout(emailCheckTimeout);
        emailExists = false;
        checkEmailExists(emailValue);
      } else {
        // Validate immediately if format is invalid
        validateField('email');
      }
    });

    // Form submit validation
    form.addEventListener('submit', (e) => {
      e.preventDefault();
      
      let isValid = true;
      Object.keys(fields).forEach(fieldName => {
        if (!validateField(fieldName)) {
          isValid = false;
        }
      });
      
      if (isValid) {
        form.submit();
      } else {
        // Focus first error field
        const firstError = form.querySelector('.field.error input');
        if (firstError) firstError.focus();
      }
    });
  </script>
  
  <% if (error != null) { %>
  <script>
    showErrorModal('<%= error %>');
  </script>
  <% } %>
  
  <style>
    .alert {
      padding: 12px 16px;
      margin-bottom: 20px;
      border-radius: 8px;
      font-size: 14px;
      line-height: 1.5;
    }
    .alert-danger {
      background-color: #fef2f2;
      border: 1px solid #fecaca;
      color: #991b1b;
    }
    .alert strong {
      font-weight: 600;
    }
    .field { position: relative; margin-bottom: 20px; }
    .field-error { 
      display: block; 
      color: #e74c3c; 
      font-size: 13px; 
      margin-top: 4px; 
      min-height: 18px;
    }
    .field-hint { 
      display: block; 
      color: #7f8c8d; 
      font-size: 12px; 
      margin-top: 2px; 
    }
    .field.error input { 
      border-color: #e74c3c !important; 
      background-color: #fef5f5 !important; 
    }
    .field.success input { 
      border-color: #27ae60 !important; 
      background-color: #f0fdf4 !important; 
    }
    .field.success::after {
      content: '✓';
      position: absolute;
      right: 12px;
      top: 38px;
      color: #27ae60;
      font-weight: bold;
      font-size: 18px;
    }
    
    /* Modal styles */
    .modal {
      display: none;
      position: fixed;
      z-index: 9999;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.6);
      justify-content: center;
      align-items: center;
      animation: fadeIn 0.3s ease;
    }
    
    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }
    
    @keyframes slideUp {
      from { 
        transform: translateY(50px);
        opacity: 0;
      }
      to { 
        transform: translateY(0);
        opacity: 1;
      }
    }
    
    .modal-content {
      background-color: white;
      padding: 40px;
      border-radius: 16px;
      max-width: 500px;
      width: 90%;
      text-align: center;
      box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
      animation: slideUp 0.3s ease;
    }
    
    .error-modal {
      border-top: 5px solid #e74c3c;
    }
    
    .modal-icon {
      font-size: 64px;
      margin-bottom: 20px;
    }
    
    .modal-title {
      font-size: 24px;
      font-weight: 700;
      color: #2c3e50;
      margin-bottom: 16px;
    }
    
    .modal-message {
      font-size: 16px;
      color: #555;
      margin-bottom: 30px;
      line-height: 1.6;
    }
    
    .modal-content .btn {
      min-width: 150px;
      padding: 12px 24px;
      font-size: 16px;
      font-weight: 600;
    }
  </style>
</body>
</html>
