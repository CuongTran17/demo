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
  <title>Marketing - PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
</head>
<body>
  <%@ include file="/includes/header.jsp" %>

  <!-- Hero Banner -->
  <section class="course-hero" style="background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);">
    <div class="course-hero-bg">
      <div class="container course-hero-content">
        <div class="python-logo">
          <svg width="120" height="120" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M3 3L10 3L10 10L3 10Z" fill="#FF4458" stroke="#fff" stroke-width="1.5"/>
            <path d="M14 3L21 3L21 10L14 10Z" fill="#FF4458" stroke="#fff" stroke-width="1.5"/>
            <path d="M3 14L10 14L10 21L3 21Z" fill="#FF4458" stroke="#fff" stroke-width="1.5"/>
            <circle cx="17.5" cy="17.5" r="3.5" fill="#FF4458" stroke="#fff" stroke-width="1.5"/>
          </svg>
        </div>
  <h1>MARKETING</h1>
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
          <img src="${pageContext.request.contextPath}/assets/img/courses-marketing/Digital Marketing.png" alt="Digital Marketing" />
          <span class="badge-new">Mới nhất</span>
          <span class="badge-discount">-50%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Digital Marketing toàn diện A-Z</h3>
          <p class="course-desc">SEO, SEM, Social Media, Email Marketing và Analytics chuyên sâu</p>
          <div class="course-meta">
            <span class="duration">⏱ 20 giờ</span>
            <span class="students">👥 5,678 học viên</span>
            <span class="level">📊 Trung bình</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">1.499.000₫</span>
              <span class="price-old">2.999.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('digital-marketing', 'Digital Marketing', 1499000)">
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
          <img src="${pageContext.request.contextPath}/assets/img/courses-marketing/Facebook Ads.png" alt="Facebook Ads" />
          <span class="badge-hot">Hot</span>
          <span class="badge-discount">-48%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Facebook Ads từ cơ bản đến chuyên sâu</h3>
          <p class="course-desc">Chiến lược quảng cáo Facebook hiệu quả cao và tối ưu chi phí</p>
          <div class="course-meta">
            <span class="duration">⏱ 16 giờ</span>
            <span class="students">👥 4,567 học viên</span>
            <span class="level">📊 Trung bình</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">1.299.000₫</span>
              <span class="price-old">2.499.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('facebook-ads', 'Facebook Ads', 1299000)">
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
          <img src="${pageContext.request.contextPath}/assets/img/courses-marketing/Google Ads.png" alt="Google Ads" />
          <span class="badge-discount">-47%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Google Ads & SEO Mastery toàn tập</h3>
          <p class="course-desc">Làm chủ quảng cáo Google và tối ưu SEO chuyên nghiệp</p>
          <div class="course-meta">
            <span class="duration">⏱ 18 giờ</span>
            <span class="students">👥 3,890 học viên</span>
            <span class="level">📊 Nâng cao</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">1.599.000₫</span>
              <span class="price-old">2.999.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('google-ads', 'Google Ads & SEO', 1599000)">
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
          <img src="${pageContext.request.contextPath}/assets/img/courses-marketing/Content Marketing.png" alt="Content Marketing" />
          <span class="badge-discount">-50%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Content Marketing & Copywriting Pro</h3>
          <p class="course-desc">Viết nội dung thu hút và chuyển đổi khách hàng hiệu quả</p>
          <div class="course-meta">
            <span class="duration">⏱ 14 giờ</span>
            <span class="students">👥 4,234 học viên</span>
            <span class="level">📊 Trung bình</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">1.199.000₫</span>
              <span class="price-old">2.399.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('content-marketing', 'Content Marketing', 1199000)">
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
          <img src="${pageContext.request.contextPath}/assets/img/courses-marketing/Social Media.png" alt="Social Media" />
          <span class="badge-discount">-48%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Social Media Marketing chuyên nghiệp</h3>
          <p class="course-desc">Xây dựng và phát triển thương hiệu trên mạng xã hội</p>
          <div class="course-meta">
            <span class="duration">⏱ 12 giờ</span>
            <span class="students">👥 5,123 học viên</span>
            <span class="level">📊 Cơ bản</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">899.000₫</span>
              <span class="price-old">1.699.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('social-media', 'Social Media Marketing', 899000)">
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
          <img src="${pageContext.request.contextPath}/assets/img/courses-marketing/Email Marketing.png" alt="Email Marketing" />
          <span class="badge-discount">-50%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Email Marketing & Automation Master</h3>
          <p class="course-desc">Tự động hóa marketing và chăm sóc khách hàng thông minh</p>
          <div class="course-meta">
            <span class="duration">⏱ 10 giờ</span>
            <span class="students">👥 3,456 học viên</span>
            <span class="level">📊 Trung bình</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">999.000₫</span>
              <span class="price-old">1.999.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('email-marketing', 'Email Marketing', 999000)">
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
          if (confirm(data.message + '\n\nBạn có muốn đăng nhập ngay không?')) {
            window.location.href = '${pageContext.request.contextPath}/login.jsp?redirect=courses-marketing';
          }
        } else if (data.success) {
          alert('✅ Đã thêm "' + courseName + '" vào giỏ hàng!');
          setTimeout(() => location.reload(), 1000);
        } else {
          alert('ℹ️ ' + data.message);
        }
      })
      .catch(error => {
        console.error('Error:', error);
        alert('❌ Có lỗi xảy ra, vui lòng thử lại');
      });
    }
    function isCoursePurchased(courseId){const p=localStorage.getItem('ptit_purchased_courses');return p?JSON.parse(p).includes(courseId):false}
    function updateCourseButtons(){document.querySelectorAll('.btn-add-cart').forEach(function(b){const m=b.getAttribute('onclick').match(/addToCart\('([^']+)'/);if(m&&isCoursePurchased(m[1])){b.innerHTML='<svg width="18" height="18" viewBox="0 0 24 24" fill="none"><path d="M8 5v14l11-7z" fill="currentColor"/></svg> Học ngay';b.className='btn-learn-now';b.setAttribute('onclick','learnCourse("'+m[1]+'")')}})}
    function learnCourse(courseId){window.location.href='${pageContext.request.contextPath}/learning.jsp?course='+courseId}
    document.addEventListener('DOMContentLoaded', updateCourseButtons);

    function scrollToCourses(){
      var el = document.getElementById('all-courses'); if(!el) return; el.scrollIntoView({behavior:'smooth',block:'start'});
    }
  </script>
</body>
</html>
