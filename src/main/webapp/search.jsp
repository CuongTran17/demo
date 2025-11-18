<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.model.Course" %>
<%@ page import="com.example.dao.CourseDAO" %>
<%
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
    
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
    String userEmail = (String) session.getAttribute("userEmail");
    String userPhone = (String) session.getAttribute("userPhone");
    
    String displayInfo = "";
    if (loggedIn != null && loggedIn) {
        if (userPhone != null && userPhone.length() >= 3) {
            displayInfo = "***" + userPhone.substring(userPhone.length() - 3);
        } else if (userEmail != null) {
            displayInfo = userEmail;
        }
    }
    
    // Get search params
    String keyword = request.getParameter("q");
    String sortBy = request.getParameter("sort");
    
    if (keyword == null) keyword = "";
    if (sortBy == null) sortBy = "newest";
    
    // Search courses from database
    CourseDAO courseDAO = new CourseDAO();
    List<Course> courses = courseDAO.searchCourses(keyword, "all", "all", sortBy);
%>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <title><%= keyword.isEmpty() ? "Tất cả khóa học" : "Tìm kiếm: " + keyword %> – PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
</head>
<body>
  <%@ include file="/includes/header.jsp" %>

  <main class="container" style="padding-top: 100px; padding-bottom: 60px;">
    <div class="page-header" style="text-align: center; margin-bottom: 50px;">
      <h1 class="page-title" style="font-size: 2.5rem; margin-bottom: 20px;">
        <% if (!keyword.isEmpty()) { %>
          🔍 Kết quả cho "<%= keyword %>"
        <% } else { %>
          📚 Tất cả khóa học
        <% } %>
      </h1>
      
      <div class="results-meta" style="display: flex; justify-content: space-between; align-items: center; max-width: 1200px; margin: 0 auto;">
        <p style="color: #666; font-size: 1.1rem;">
          Hiển thị <strong style="color: #667eea;"><%= courses.size() %></strong> khóa học
        </p>
        <select onchange="window.location.href='?q=<%= keyword %>&sort=' + this.value" style="padding: 10px 20px; border: 2px solid #e0e0e0; border-radius: 8px; font-size: 1rem; cursor: pointer; outline: none; transition: border-color 0.3s;" onfocus="this.style.borderColor='#667eea'" onblur="this.style.borderColor='#e0e0e0'">
          <option value="newest" <%= "newest".equals(sortBy) ? "selected" : "" %>>🆕 Mới nhất</option>
          <option value="popular" <%= "popular".equals(sortBy) ? "selected" : "" %>>🔥 Phổ biến nhất</option>
          <option value="price_low" <%= "price_low".equals(sortBy) ? "selected" : "" %>>💰 Giá thấp → cao</option>
          <option value="price_high" <%= "price_high".equals(sortBy) ? "selected" : "" %>>💎 Giá cao → thấp</option>
        </select>
      </div>
    </div>

    <% if (courses.isEmpty()) { %>
      <div style="text-align: center; padding: 80px 20px; background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%); border-radius: 16px;">
        <div style="font-size: 5rem; margin-bottom: 20px;">😕</div>
        <h2 style="font-size: 2rem; margin-bottom: 15px; color: #1a1a1a;">Không tìm thấy khóa học nào</h2>
        <p style="color: #666; font-size: 1.1rem; margin-bottom: 30px;">Thử tìm kiếm với từ khóa khác hoặc khám phá tất cả khóa học</p>
        <a href="${pageContext.request.contextPath}/" style="display: inline-block; padding: 15px 35px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; text-decoration: none; border-radius: 8px; font-weight: 600; font-size: 1.1rem; transition: transform 0.3s, box-shadow 0.3s;" onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 8px 20px rgba(102,126,234,0.4)'" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='none'">Về trang chủ</a>
      </div>
    <% } else { %>
      <div class="courses-grid">
        <% for (Course course : courses) { %>
          <article class="course-card">
            <div class="course-thumbnail">
              <img src="${pageContext.request.contextPath}/assets/img/courses-<%= course.getCategory() %>/<%= course.getCourseId() %>.png" alt="<%= course.getCourseName() %>" onerror="this.src='${pageContext.request.contextPath}/assets/img/placeholder.png'" />
              <% if (course.getDiscountPercentage() > 0) { %>
                <span class="badge-discount">-<%= course.getDiscountPercentage() %>%</span>
              <% } %>
              <% if (course.isNew()) { %>
                <span class="badge-new">Mới</span>
              <% } %>
            </div>
            <div class="course-content">
              <h3 class="course-name"><%= course.getCourseName() %></h3>
              <p class="course-desc"><%= course.getDescription() != null ? course.getDescription() : "" %></p>
              <div class="course-meta">
                <% if (course.getDuration() != null) { %>
                  <span class="duration">⏱ <%= course.getDuration() %></span>
                <% } %>
                <span class="students">👥 <%= String.format("%,d", course.getStudentsCount()) %> học viên</span>
                <% if (course.getLevel() != null) { %>
                  <span class="level">📊 <%= course.getLevel() %></span>
                <% } %>
              </div>
              <div class="course-footer">
                <div class="course-price">
                  <span class="price-current"><%= String.format("%,d", course.getPrice().intValue()) %>₫</span>
                  <% if (course.getOldPrice().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                    <span class="price-old"><%= String.format("%,d", course.getOldPrice().intValue()) %>₫</span>
                  <% } %>
                </div>
                <button class="btn-add-cart" onclick="addToCart('<%= course.getCourseId() %>', '<%= course.getCourseName().replace("'", "&#39;") %>', <%= course.getPrice() %>)">
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
      </div>
    <% } %>
  </main>

  <%@ include file="/includes/footer.jsp" %>

  <script>
    window.contextPath = '${pageContext.request.contextPath}';
    window.isUserLoggedIn = <%= loggedIn != null && loggedIn ? "true" : "false" %>;
  </script>
  <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/cart.js"></script>
</body>
</html>
