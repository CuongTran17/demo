<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.model.Course" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
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
      <%
      int courseIndex = 0;
      String[] cardClasses = {"course-card", "course-card course-card-horizontal", "course-card course-card-large", "course-card", "course-card", "course-card"};

      for (Course course : courses) {
          String cardClass = cardClasses[courseIndex % cardClasses.length];
          courseIndex++;

          // Get thumbnail image path
          String imgPath = course.getThumbnail() != null && !course.getThumbnail().isEmpty()
              ? course.getThumbnail()
              : "${pageContext.request.contextPath}/assets/img/courses-accounting/" + course.getCourseName() + ".png";

          // Format level
          String levelText = "Cơ bản";
          if ("Intermediate".equalsIgnoreCase(course.getLevel()) || "Trung bình".equalsIgnoreCase(course.getLevel())) {
              levelText = "Trung bình";
          } else if ("Advanced".equalsIgnoreCase(course.getLevel()) || "Nâng cao".equalsIgnoreCase(course.getLevel())) {
              levelText = "Nâng cao";
          } else if ("All".equalsIgnoreCase(course.getLevel()) || "Tất cả".equalsIgnoreCase(course.getLevel())) {
              levelText = "Tất cả";
          }
      %>
      <!-- Course <%= courseIndex %> -->
      <article class="<%= cardClass %>">
        <div class="course-thumbnail">
          <img src="<%= imgPath %>" alt="<%= course.getCourseName() %>" onerror="this.src='${pageContext.request.contextPath}/assets/img/courses-accounting/default.png'" />
          <% if (course.isNew()) { %>
          <span class="badge-new">Mới nhất</span>
          <% } %>
          <% if (course.getDiscountPercentage() > 0) { %>
          <span class="badge-discount">-<%= course.getDiscountPercentage() %>%</span>
          <% } %>
        </div>
        <div class="course-content">
          <h3 class="course-name"><%= course.getCourseName() %></h3>
          <p class="course-desc"><%= course.getDescription() != null ? course.getDescription() : "" %></p>
          <div class="course-meta">
            <span class="duration">⏱ <%= course.getDuration() %></span>
            <span class="students">👥 <%= currencyFormat.format(course.getStudentsCount()) %> học viên</span>
            <span class="level">📊 <%= levelText %></span>
          </div>
          <div class="course-footer">
            <div class="course-price">
              <span class="price-current"><%= currencyFormat.format(course.getPrice().longValue()) %>₫</span>
              <% if (course.getOldPrice() != null && course.getOldPrice().compareTo(course.getPrice()) > 0) { %>
              <span class="price-old"><%= currencyFormat.format(course.getOldPrice().longValue()) %>₫</span>
              <% } %>
            </div>
            <button class="btn-add-cart course-action-btn" data-course-id="<%= course.getCourseId() %>" onclick="addToCart('<%= course.getCourseId() %>', '<%= course.getCourseName().replace("'", "\\'") %>', <%= course.getPrice().longValue() %>)">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 2L7 6H3L5 20H19L21 6H17L15 2H9Z" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M9 10V6M15 10V6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
              </svg>
              Thêm vào giỏ
            </button>
          </div>
        </div>
      </article>
      <% } %>

      <% if (courses.isEmpty()) { %>
      <div style="grid-column: 1 / -1; text-align: center; padding: 60px 20px;">
        <h3>Chưa có khóa học nào</h3>
        <p style="color: #666;">Các khóa học Kế toán sẽ sớm được cập nhật</p>
      </div>
      <% } %>
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

    function scrollToCourses(){
      var el = document.getElementById('all-courses'); if(!el) return; el.scrollIntoView({behavior:'smooth',block:'start'});
    }
  </script>
</body>
</html>
