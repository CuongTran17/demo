<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.model.Course" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.math.BigDecimal" %>
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

    // Get courses from request attribute (set by servlet)
    @SuppressWarnings("unchecked")
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    if (courses == null) {
        courses = new java.util.ArrayList<>();
    }

    NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
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
      <%
        if (courses != null && !courses.isEmpty()) {
          for (Course course : courses) {
      %>
      <article class="course-card">
        <div class="course-thumbnail">
          <img src="<%= course.getThumbnail() != null && !course.getThumbnail().isEmpty() 
            ? pageContext.getServletContext().getContextPath() + course.getThumbnail() 
            : pageContext.getServletContext().getContextPath() + "/assets/img/courses-finance/default.png" %>" 
            alt="<%= course.getCourseName() %>" />
          <% if (course.isNew()) { %>
            <span class="badge-new">Mới nhất</span>
          <% } %>
          <% if (course.getDiscountPercentage() > 0) { %>
            <span class="badge-discount">-<%= course.getDiscountPercentage() %>%</span>
          <% } %>
        </div>
        <div class="course-content">
          <h3 class="course-name"><%= course.getCourseName() %></h3>
          <p class="course-desc"><%= course.getDescription() %></p>
          <div class="course-meta">
            <span class="duration">⏱ <%= course.getDuration() %> giờ</span>
            <span class="students">👥 <%= course.getStudentsCount() %> học viên</span>
            <span class="level">📊 <%= course.getLevel() %></span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current"><%= currencyFormat.format(course.getPrice()) %></span>
              <% if (course.getOldPrice() != null && course.getOldPrice().compareTo(BigDecimal.ZERO) > 0) { %>
                <span class="price-old"><%= currencyFormat.format(course.getOldPrice()) %></span>
              <% } %>
            </div>
            <button class="btn-add-cart course-action-btn" data-course-id="<%= course.getCourseId() %>" onclick="addToCart('<%= course.getCourseId() %>', '<%= course.getCourseName() %>', <%= course.getPrice() %>)">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 2L7 6H3L5 20H19L21 6H17L15 2H9Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M9 10V6M15 10V6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
              </svg>
              Thêm vào giỏ
            </button>
          </div>
        </div>
      </article>
      <%
          }
        } else {
      %>
      <div class="no-courses">
        <p>Không có khóa học nào trong danh mục này.</p>
      </div>
      <%
        }
      %>
    </div>
  </main>

  <%@ include file="/includes/footer.jsp" %>

  <script>
    // Check purchased courses on page load
    document.addEventListener('DOMContentLoaded', function() {
      <% if (loggedIn != null && loggedIn) { %>
        fetch('${pageContext.request.contextPath}/api/purchased-courses')
          .then(response => response.json())
          .then(data => {
            if (data.purchasedCourses && data.purchasedCourses.length > 0) {
              const purchasedIds = data.purchasedCourses;
              
              // Update buttons for purchased courses
              document.querySelectorAll('.course-action-btn').forEach(btn => {
                const courseId = btn.getAttribute('data-course-id');
                if (purchasedIds.includes(courseId)) {
                  // Course already purchased
                  btn.innerHTML = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M20 6L9 17L4 12" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg> Vào học';
                  btn.className = 'btn-learn-now';
                  btn.onclick = function() {
                    window.location.href = '${pageContext.request.contextPath}/learning.jsp?courseId=' + courseId;
                  };
                }
              });
            }
          })
          .catch(error => console.error('Error checking purchased courses:', error));
      <% } %>
    });
    
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
          // User not logged in - show login prompt
          if (confirm(data.message + '\n\nBạn có muốn đăng nhập ngay không?')) {
            window.location.href = '${pageContext.request.contextPath}/login.jsp?redirect=courses-finance';
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

    function scrollToCourses(){
      var el = document.getElementById('all-courses'); if(!el) return; el.scrollIntoView({behavior:'smooth',block:'start'});
    }
  </script>
</body>
</html>
