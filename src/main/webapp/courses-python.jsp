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
  <title>Lập trình - CNTT - PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
</head>
<body>
  <%@ include file="/includes/header.jsp" %>

  <!-- Hero Banner -->
  <section class="course-hero">
    <div class="course-hero-bg">
      <div class="matrix-rain"></div>
      <div class="container course-hero-content">
        <div class="python-logo">
          <svg width="120" height="120" viewBox="0 0 256 255" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet">
            <defs>
              <linearGradient x1="12.959%" y1="12.039%" x2="79.639%" y2="78.201%" id="a">
                <stop stop-color="#387EB8" offset="0%"/>
                <stop stop-color="#366994" offset="100%"/>
              </linearGradient>
              <linearGradient x1="19.128%" y1="20.579%" x2="90.742%" y2="88.429%" id="b">
                <stop stop-color="#FFE052" offset="0%"/>
                <stop stop-color="#FFC331" offset="100%"/>
              </linearGradient>
            </defs>
            <path d="M126.916.072c-64.832 0-60.784 28.115-60.784 28.115l.072 29.128h61.868v8.745H41.631S.145 61.355.145 126.77c0 65.417 36.21 63.097 36.21 63.097h21.61v-30.356s-1.165-36.21 35.632-36.21h61.362s34.475.557 34.475-33.319V33.97S194.67.072 126.916.072zM92.802 19.66a11.12 11.12 0 0 1 11.13 11.13 11.12 11.12 0 0 1-11.13 11.13 11.12 11.12 0 0 1-11.13-11.13 11.12 11.12 0 0 1 11.13-11.13z" fill="url(#a)"/>
            <path d="M128.757 254.126c64.832 0 60.784-28.115 60.784-28.115l-.072-29.127H127.6v-8.745h86.441s41.486 4.705 41.486-60.712c0-65.416-36.21-63.096-36.21-63.096h-21.61v30.355s1.165 36.21-35.632 36.21h-61.362s-34.475-.557-34.475 33.32v56.013s-5.235 33.897 62.518 33.897zm34.114-19.586a11.12 11.12 0 0 1-11.13-11.13 11.12 11.12 0 0 1 11.13-11.131 11.12 11.12 0 0 1 11.13 11.13 11.12 11.12 0 0 1-11.13 11.13z" fill="url(#b)"/>
          </svg>
        </div>
  <h1>PYTHON</h1>
  <button class="btn-hero" onclick="scrollToCourses()">Tìm hiểu thêm</button>
      </div>
    </div>
  </section>

  <!-- Course List -->
  <main class="container courses-page">
  <h2 id="all-courses" class="courses-title">Tất cả khóa học</h2>

    <div class="courses-grid">
      <!-- Course 1 -->
      <article class="course-card">
        <div class="course-thumbnail">
          <img src="${pageContext.request.contextPath}/assets/img/python-procedural.jpg" alt="Procedural Python" />
          <span class="badge-new">Mới nhất</span>
          <span class="badge-discount">-48%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Procedural Python - Lập trình hàm trong Python</h3>
          <p class="course-desc">Học lập trình hàm trong Python từ cơ bản đến nâng cao, áp dụng vào dự án thực tế</p>
          <div class="course-meta">
            <span class="duration">⏱ 12 giờ</span>
            <span class="students">👥 1,234 học viên</span>
            <span class="level">📊 Cơ bản</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">1.299.000₫</span>
              <span class="price-old">2.499.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('python-procedural', 'Procedural Python', 1299000)">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 2L7 6H3L5 20H19L21 6H17L15 2H9Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M9 10V6M15 10V6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
              </svg>
              Thêm vào giỏ
            </button>
          </div>
        </div>
      </article>

      <!-- Course 2 -->
      <article class="course-card course-card-horizontal">
        <div class="course-thumbnail">
          <img src="${pageContext.request.contextPath}/assets/img/python-basics.jpg" alt="Python Basics" />
          <span class="badge-hot">Hot</span>
          <span class="badge-discount">-50%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Python Basics - Python Cơ Bản</h3>
          <p class="course-desc">Khóa học Python cơ bản dành cho người mới bắt đầu, không cần kiến thức lập trình trước</p>
          <div class="course-meta">
            <span class="duration">⏱ 15 giờ</span>
            <span class="students">👥 2,845 học viên</span>
            <span class="level">📊 Cơ bản</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">999.000₫</span>
              <span class="price-old">1.999.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('python-basics', 'Python Basics', 999000)">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 2L7 6H3L5 20H19L21 6H17L15 2H9Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M9 10V6M15 10V6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
              </svg>
              Thêm vào giỏ
            </button>
          </div>
        </div>
      </article>

      <!-- Course 3 -->
      <article class="course-card course-card-large">
        <div class="course-thumbnail">
          <img src="${pageContext.request.contextPath}/assets/img/python.jpg" alt="Python" />
          <span class="badge-discount">-50%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Python Toàn Tập - Từ Zero đến Hero</h3>
          <p class="course-desc">Khóa học Python toàn diện nhất, bao gồm tất cả kiến thức từ cơ bản đến nâng cao</p>
          <div class="course-meta">
            <span class="duration">⏱ 40 giờ</span>
            <span class="students">👥 5,678 học viên</span>
            <span class="level">📊 Tất cả</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">2.499.000₫</span>
              <span class="price-old">4.999.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('python-complete', 'Python Toàn Tập', 2499000)">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 2L7 6H3L5 20H19L21 6H17L15 2H9Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M9 10V6M15 10V6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
              </svg>
              Thêm vào giỏ
            </button>
          </div>
        </div>
      </article>

      <!-- Course 4 -->
      <article class="course-card">
        <div class="course-thumbnail">
          <img src="${pageContext.request.contextPath}/assets/img/python-excel.jpg" alt="Python Excel" />
          <span class="badge-discount">-50%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Python Excel cho người đi làm</h3>
          <p class="course-desc">Tự động hóa công việc Excel bằng Python, tiết kiệm hàng giờ làm việc mỗi ngày</p>
          <div class="course-meta">
            <span class="duration">⏱ 8 giờ</span>
            <span class="students">👥 1,890 học viên</span>
            <span class="level">📊 Trung bình</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">899.000₫</span>
              <span class="price-old">1.799.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('python-excel', 'Python Excel', 899000)">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 2L7 6H3L5 20H19L21 6H17L15 2H9Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M9 10V6M15 10V6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
              </svg>
              Thêm vào giỏ
            </button>
          </div>
        </div>
      </article>

      <!-- Course 5 -->
      <article class="course-card">
        <div class="course-thumbnail">
          <img src="${pageContext.request.contextPath}/assets/img/selenium-python.jpg" alt="Selenium Python" />
          <span class="badge-discount">-47%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Selenium Python - Test Automation</h3>
          <p class="course-desc">Học automation testing với Selenium và Python cho web application</p>
          <div class="course-meta">
            <span class="duration">⏱ 18 giờ</span>
            <span class="students">👥 987 học viên</span>
            <span class="level">📊 Nâng cao</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">1.599.000₫</span>
              <span class="price-old">2.999.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('selenium-python', 'Selenium Python', 1599000)">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 2L7 6H3L5 20H19L21 6H17L15 2H9Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M9 10V6M15 10V6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
              </svg>
              Thêm vào giỏ
            </button>
          </div>
        </div>
      </article>

      <!-- Course 6 -->
      <article class="course-card">
        <div class="course-thumbnail">
          <img src="${pageContext.request.contextPath}/assets/img/python-oop.jpg" alt="Python OOP" />
          <span class="badge-discount">-48%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Lập trình hướng đối tượng Python OOP</h3>
          <p class="course-desc">Nắm vững OOP trong Python, xây dựng ứng dụng có cấu trúc tốt và dễ bảo trì</p>
          <div class="course-meta">
            <span class="duration">⏱ 10 giờ</span>
            <span class="students">👥 1,456 học viên</span>
            <span class="level">📊 Trung bình</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">1.199.000₫</span>
              <span class="price-old">2.299.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('python-oop', 'Python OOP', 1199000)">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 2L7 6H3L5 20H19L21 6H17L15 2H9Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M9 10V6M15 10V6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
              </svg>
              Thêm vào giỏ
            </button>
          </div>
        </div>
      </article>
    </div>
  </main>

  <%@ include file="/includes/footer.jsp" %>

  <script>
    // Set context variables for shared scripts
    window.contextPath = '${pageContext.request.contextPath}';
    window.isUserLoggedIn = <%= loggedIn != null && loggedIn ? "true" : "false" %>;
  </script>
  <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/cart.js"></script>
  <script>
    // Matrix rain effect (specific to Python course page)
    const matrixRain = document.querySelector('.matrix-rain');
    if (matrixRain) {
      const chars = '01';
      const columns = Math.floor(window.innerWidth / 20);
      
      for (let i = 0; i < columns; i++) {
        const column = document.createElement('div');
        column.className = 'matrix-column';
        column.style.left = (i * 20) + 'px';
        column.style.animationDelay = (Math.random() * 5) + 's';
        
        let text = '';
        for (let j = 0; j < 30; j++) {
          text += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        column.textContent = text;
        matrixRain.appendChild(column);
      }
    }

    // Add to cart function with AJAX
    function addToCart(courseId, courseName, price) {
      fetch('${pageContext.request.contextPath}/cart', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'action=add&courseId=' + courseId
      })
      .then(response => response.json())
      .then(data => {
        if (data.requireLogin) {
          // User not logged in - show login prompt
          if (confirm(data.message + '\n\nBạn có muốn đăng nhập ngay không?')) {
            window.location.href = '${pageContext.request.contextPath}/login.jsp?redirect=courses-python';
          }
        } else if (data.success) {
          showNotification('✅ Đã thêm "' + courseName + '" vào giỏ hàng!', 'success');
          // Update cart count if exists
          setTimeout(() => location.reload(), 1500);
        } else {
          showNotification('ℹ️ ' + data.message, 'info');
        }
      })
      .catch(error => {
        console.error('Error:', error);
        showNotification('❌ Có lỗi xảy ra, vui lòng thử lại', 'error');
      });
    }

    // Show notification
    function showNotification(message, type) {
      const notification = document.createElement('div');
      notification.className = 'notification notification-' + type;
      notification.textContent = message;
      
      let bgColor = '#2196F3';
      if (type === 'success') bgColor = '#4CAF50';
      else if (type === 'error') bgColor = '#f44336';
      
      notification.style.cssText = 
        'position: fixed;' +
        'top: 100px;' +
        'right: 20px;' +
        'padding: 16px 24px;' +
        'background: ' + bgColor + ';' +
        'color: white;' +
        'border-radius: 8px;' +
        'box-shadow: 0 4px 12px rgba(0,0,0,0.15);' +
        'font-weight: 600;' +
        'z-index: 10000;' +
        'animation: slideIn 0.3s ease;';
      
      document.body.appendChild(notification);
      
      setTimeout(function() {
        notification.style.animation = 'slideOut 0.3s ease';
        setTimeout(function() { notification.remove(); }, 300);
      }, 3000);
    }
  </script>
  
  <style>
    @keyframes slideIn {
      from { transform: translateX(400px); opacity: 0; }
      to { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOut {
      from { transform: translateX(0); opacity: 1; }
      to { transform: translateX(400px); opacity: 0; }
    }
  </style>
</body>
</html>

