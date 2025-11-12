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
  <title>Kế toán - PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
</head>
<body>
  <%@ include file="/includes/header.jsp" %>

  <!-- Hero Banner -->
  <section class="course-hero" style="background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);">
    <div class="course-hero-bg">
      <div class="container course-hero-content">
        <div class="python-logo">
          <svg width="120" height="120" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M4 4H20V7H4V4Z" fill="#00C851"/>
            <path d="M4 9H20V12H4V9Z" fill="#00C851"/>
            <path d="M4 14H20V17H4V14Z" fill="#00C851"/>
            <path d="M4 19H20V20H4V19Z" fill="#00C851" stroke="#00C851" stroke-width="2"/>
            <circle cx="6" cy="5.5" r="0.8" fill="#fff"/>
            <circle cx="6" cy="10.5" r="0.8" fill="#fff"/>
            <circle cx="6" cy="15.5" r="0.8" fill="#fff"/>
          </svg>
        </div>
  <h1>KẾ TOÁN</h1>
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
          <img src="${pageContext.request.contextPath}/assets/img/accounting-basic.jpg" alt="Kế toán cơ bản" />
          <span class="badge-new">Mới nhất</span>
          <span class="badge-discount">-50%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Kế toán cơ bản cho người mới bắt đầu</h3>
          <p class="course-desc">Nguyên lý kế toán và các khái niệm nền tảng trong kế toán</p>
          <div class="course-meta">
            <span class="duration">⏱ 14 giờ</span>
            <span class="students">👥 4,567 học viên</span>
            <span class="level">📊 Cơ bản</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">699.000₫</span>
              <span class="price-old">1.399.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('accounting-basic', 'Kế toán cơ bản', 699000)">
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
          <img src="${pageContext.request.contextPath}/assets/img/accounting-misa.jpg" alt="MISA" />
          <span class="badge-hot">Hot</span>
          <span class="badge-discount">-48%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Kế toán với phần mềm MISA toàn tập</h3>
          <p class="course-desc">Thực hành kế toán chuyên nghiệp với MISA từ A đến Z</p>
          <div class="course-meta">
            <span class="duration">⏱ 16 giờ</span>
            <span class="students">👥 3,890 học viên</span>
            <span class="level">📊 Trung bình</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">1.299.000₫</span>
              <span class="price-old">2.499.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('accounting-misa', 'Kế toán MISA', 1299000)">
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
          <img src="${pageContext.request.contextPath}/assets/img/tax-accounting.jpg" alt="Kế toán thuế" />
          <span class="badge-discount">-50%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Kế toán thuế doanh nghiệp chuyên sâu</h3>
          <p class="course-desc">Tổng hợp thuế GTGT, TNDN, TNCN và quyết toán thuế chi tiết</p>
          <div class="course-meta">
            <span class="duration">⏱ 18 giờ</span>
            <span class="students">👥 2,456 học viên</span>
            <span class="level">📊 Nâng cao</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">1.499.000₫</span>
              <span class="price-old">2.999.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('tax-accounting', 'Kế toán thuế', 1499000)">
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
          <img src="${pageContext.request.contextPath}/assets/img/cost-accounting.jpg" alt="Kế toán chi phí" />
          <span class="badge-discount">-47%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Kế toán quản trị chi phí hiệu quả</h3>
          <p class="course-desc">Phân tích và kiểm soát chi phí hiệu quả cho doanh nghiệp</p>
          <div class="course-meta">
            <span class="duration">⏱ 12 giờ</span>
            <span class="students">👥 1,789 học viên</span>
            <span class="level">📊 Trung bình</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">899.000₫</span>
              <span class="price-old">1.699.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('cost-accounting', 'Kế toán chi phí', 899000)">
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
          <img src="${pageContext.request.contextPath}/assets/img/excel-accounting.jpg" alt="Excel kế toán" />
          <span class="badge-discount">-50%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Excel cho kế toán chuyên nghiệp</h3>
          <p class="course-desc">Tự động hóa công việc kế toán với Excel nâng cao và VBA</p>
          <div class="course-meta">
            <span class="duration">⏱ 10 giờ</span>
            <span class="students">👥 5,234 học viên</span>
            <span class="level">📊 Trung bình</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">799.000₫</span>
              <span class="price-old">1.599.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('excel-accounting', 'Excel kế toán', 799000)">
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
          <img src="${pageContext.request.contextPath}/assets/img/financial-statements.jpg" alt="Báo cáo tài chính" />
          <span class="badge-discount">-48%</span>
        </div>
        <div class="course-content">
          <h3 class="course-name">Lập và phân tích báo cáo tài chính</h3>
          <p class="course-desc">Báo cáo tài chính theo chuẩn Việt Nam và IFRS quốc tế</p>
          <div class="course-meta">
            <span class="duration">⏱ 16 giờ</span>
            <span class="students">👥 2,678 học viên</span>
            <span class="level">📊 Nâng cao</span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current">1.399.000₫</span>
              <span class="price-old">2.699.000₫</span>
            </div>
            <button class="btn-add-cart" onclick="addToCart('financial-statements', 'Báo cáo tài chính', 1399000)">
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
            window.location.href = '${pageContext.request.contextPath}/login.jsp?redirect=courses-accounting';
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
