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
  <title>Tài chính - PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
</head>
<body>
  <%@ include file="/includes/header.jsp" %>

  <!-- Hero Banner -->
  <section class="course-hero" style="background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);">
    <div class="course-hero-bg">
      <div class="container course-hero-content">
        <div class="python-logo">
          <svg width="120" height="120" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M12 2L2 7L12 12L22 7L12 2Z" fill="#FFD700" stroke="#FFA500" stroke-width="1.5"/>
            <path d="M2 17L12 22L22 17" stroke="#FFD700" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            <path d="M2 12L12 17L22 12" stroke="#FFD700" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
  <h1>TÀI CHÍNH</h1>
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
          <img src="${pageContext.request.contextPath}/assets/img/finance-basic.jpg" alt="Tài chính cơ bản" />
          <span class="badge-new">Mới nhất</span>
          <span class="badge-discount">-50%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Tài chính cơ bản cho người mới bắt đầu</h3>
          <p class="course-desc">Học các khái niệm tài chính nền tảng, quản lý chi tiêu cá nhân hiệu quả</p>
          <div class="course-meta">
            <span class="duration">⏱ 10 giờ</span>
            <span class="students">👥 2,145 học viên</span>
            <span class="level">📊 Cơ bản</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">799.000₫</span>
              <span class="price-old">1.599.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('finance-basic', 'Tài chính cơ bản', 799000)">
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
      <article class="course-card">
        <div class="course-thumbnail">
          <img src="${pageContext.request.contextPath}/assets/img/investment.jpg" alt="Đầu tư chứng khoán" />
          <span class="badge-hot">Hot</span>
          <span class="badge-discount">-45%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Đầu tư chứng khoán từ A-Z</h3>
          <p class="course-desc">Phân tích kỹ thuật, phân tích cơ bản và chiến lược đầu tư thông minh</p>
          <div class="course-meta">
            <span class="duration">⏱ 20 giờ</span>
            <span class="students">👥 3,890 học viên</span>
            <span class="level">📊 Trung bình</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">1.699.000₫</span>
              <span class="price-old">2.999.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('investment', 'Đầu tư chứng khoán', 1699000)">
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
      <article class="course-card">
        <div class="course-thumbnail">
          <img src="${pageContext.request.contextPath}/assets/img/banking.jpg" alt="Ngân hàng" />
          <span class="badge-discount">-48%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Nghiệp vụ ngân hàng hiện đại</h3>
          <p class="course-desc">Tìm hiểu về hoạt động ngân hàng và các dịch vụ tài chính đương đại</p>
          <div class="course-meta">
            <span class="duration">⏱ 15 giờ</span>
            <span class="students">👥 1,567 học viên</span>
            <span class="level">📊 Trung bình</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">1.299.000₫</span>
              <span class="price-old">2.499.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('banking', 'Nghiệp vụ ngân hàng', 1299000)">
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
          <img src="${pageContext.request.contextPath}/assets/img/personal-finance.jpg" alt="Tài chính cá nhân" />
          <span class="badge-discount">-50%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Quản lý tài chính cá nhân thông minh</h3>
          <p class="course-desc">Lập kế hoạch tài chính, tiết kiệm và đầu tư hiệu quả cho tương lai</p>
          <div class="course-meta">
            <span class="duration">⏱ 12 giờ</span>
            <span class="students">👥 4,321 học viên</span>
            <span class="level">📊 Cơ bản</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">699.000₫</span>
              <span class="price-old">1.399.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('personal-finance', 'Tài chính cá nhân', 699000)">
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
          <img src="${pageContext.request.contextPath}/assets/img/forex.jpg" alt="Forex" />
          <span class="badge-discount">-47%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Trading Forex cho người mới</h3>
          <p class="course-desc">Giao dịch ngoại hối và quản trị rủi ro chuyên nghiệp</p>
          <div class="course-meta">
            <span class="duration">⏱ 16 giờ</span>
            <span class="students">👥 2,678 học viên</span>
            <span class="level">📊 Nâng cao</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">1.599.000₫</span>
              <span class="price-old">2.999.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('forex', 'Trading Forex', 1599000)">
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
          <img src="${pageContext.request.contextPath}/assets/img/financial-analysis.jpg" alt="Phân tích tài chính" />
          <span class="badge-discount">-50%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Phân tích báo cáo tài chính doanh nghiệp</h3>
          <p class="course-desc">Đọc hiểu và phân tích báo cáo tài chính chuyên nghiệp</p>
          <div class="course-meta">
            <span class="duration">⏱ 14 giờ</span>
            <span class="students">👥 1,892 học viên</span>
            <span class="level">📊 Nâng cao</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">1.499.000₫</span>
              <span class="price-old">2.999.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('financial-analysis', 'Phân tích báo cáo TC', 1499000)">
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
    const btn = document.getElementById('hamburger');
    const menu = document.querySelector('.menu');
    if(btn && menu){
      btn.addEventListener('click', () => {
        const open = btn.getAttribute('aria-expanded') === 'true';
        btn.setAttribute('aria-expanded', String(!open));
        menu.classList.toggle('open');
      });
    }

    // Dropdown menu toggle (click-based)
    const ddTrigger = document.querySelector('.menu .has-dd');
    const ddParent = ddTrigger ? ddTrigger.closest('.dropdown') : null;
    if(ddTrigger && ddParent){
      ddTrigger.addEventListener('click', (e)=>{
        e.preventDefault();
        ddParent.classList.toggle('open');
        const expanded = ddTrigger.getAttribute('aria-expanded') === 'true';
        ddTrigger.setAttribute('aria-expanded', String(!expanded));
      });
      
      // Close dropdown when clicking outside
      document.addEventListener('click', (e) => {
        if (!ddParent.contains(e.target)) {
          ddParent.classList.remove('open');
          ddTrigger.setAttribute('aria-expanded', 'false');
        }
      });
    }

    // Cart management functions
    function getCart() {
      const cart = localStorage.getItem('ptit_cart');
      return cart ? JSON.parse(cart) : [];
    }

    function saveCart(cart) {
      localStorage.setItem('ptit_cart', JSON.stringify(cart));
    }

    function addToCart(courseId, courseName, price) {
      const isLoggedIn = <%= loggedIn != null && loggedIn ? "true" : "false" %>;
      if (!isLoggedIn) {
        alert('⚠️ Vui lòng đăng nhập để thêm khóa học vào giỏ hàng!');
        window.location.href = '${pageContext.request.contextPath}/login.jsp?redirect=courses-finance';
        return;
      }
      
      const cart = getCart();
      const existing = cart.find(item => item.id === courseId);
      
      if (existing) {
        alert('Khóa học này đã có trong giỏ hàng!');
        return;
      }

      cart.push({
        id: courseId,
        name: courseName,
        price: price,
        quantity: 1
      });

      saveCart(cart);
      alert('Đã thêm "' + courseName + '" vào giỏ hàng!');
      location.reload();
    }

    function isCoursePurchased(courseId) {
      const purchased = localStorage.getItem('ptit_purchased_courses');
      if (!purchased) return false;
      return JSON.parse(purchased).includes(courseId);
    }

    function updateCourseButtons() {
      document.querySelectorAll('.btn-add-cart').forEach(function(button) {
        const match = button.getAttribute('onclick').match(/addToCart\('([^']+)'/);
        if (match && isCoursePurchased(match[1])) {
          button.innerHTML = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none"><path d="M8 5v14l11-7z" fill="currentColor"/></svg> Học ngay';
          button.className = 'btn-learn-now';
          button.setAttribute('onclick', 'learnCourse("' + match[1] + '")');
        }
      });
    }

    function learnCourse(courseId) {
      window.location.href = '${pageContext.request.contextPath}/learning.jsp?course=' + courseId;
    }

    document.addEventListener('DOMContentLoaded', updateCourseButtons);

    function scrollToCourses(){
      var el = document.getElementById('all-courses'); if(!el) return; el.scrollIntoView({behavior:'smooth',block:'start'});
    }
  </script>
</body>
</html>
