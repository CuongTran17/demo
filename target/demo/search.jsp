<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.model.Course" %>
<%@ page import="com.example.dao.CourseDAO" %>
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
    
    // Get search params
    String keyword = request.getParameter("q");
    String category = request.getParameter("category");
    String priceRange = request.getParameter("price");
    String sortBy = request.getParameter("sort");
    
    if (keyword == null) keyword = "";
    if (category == null) category = "all";
    if (priceRange == null) priceRange = "all";
    if (sortBy == null) sortBy = "newest";
    
    // Search courses from database
    CourseDAO courseDAO = new CourseDAO();
    List<Course> courses = courseDAO.searchCourses(keyword, category, priceRange, sortBy);
%>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <title>Tìm kiếm khóa học – PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
  <style>
    /* Search Page Specific Styles */
    body {
      font-family: 'Be Vietnam Pro', sans-serif;
    }
    
    .search-header {
      text-align: center;
      margin-bottom: 40px;
    }
    
    .search-header .page-title {
      font-size: 2.5rem;
      margin-bottom: 20px;
      color: #1a1a1a;
      font-family: 'Be Vietnam Pro', sans-serif;
    }
    
    .search-form {
      max-width: 600px;
      margin: 0 auto;
    }
    
    .search-input-wrapper {
      display: flex;
      gap: 10px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      border-radius: 8px;
      overflow: hidden;
    }
    
    .search-input {
      flex: 1;
      padding: 15px 20px;
      border: none;
      font-size: 1rem;
      outline: none;
      font-family: 'Be Vietnam Pro', sans-serif;
    }
    
    .search-btn {
      padding: 15px 30px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      cursor: pointer;
      font-weight: 600;
      transition: opacity 0.3s;
      font-family: 'Be Vietnam Pro', sans-serif;
    }
    
    .search-btn:hover {
      opacity: 0.9;
    }
    
    .search-layout {
      display: grid;
      grid-template-columns: 280px 1fr;
      gap: 40px;
      margin-top: 40px;
    }
    
    .search-sidebar {
      background: white;
      padding: 30px;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      height: fit-content;
      position: sticky;
      top: 100px;
    }
    
    .filter-section {
      margin-bottom: 30px;
    }
    
    .filter-section:last-of-type {
      margin-bottom: 20px;
    }
    
    .filter-title {
      font-size: 1.1rem;
      font-weight: 700;
      margin-bottom: 15px;
      color: #1a1a1a;
      font-family: 'Be Vietnam Pro', sans-serif;
    }
    
    .filter-options {
      display: flex;
      flex-direction: column;
      gap: 10px;
    }
    
    .filter-option {
      display: flex;
      align-items: center;
      gap: 10px;
      cursor: pointer;
      padding: 8px 0;
      transition: color 0.2s;
      font-family: 'Be Vietnam Pro', sans-serif;
    }
    
    .filter-option:hover {
      color: #667eea;
    }
    
    .filter-option input[type="radio"] {
      cursor: pointer;
    }
    
    .btn-block {
      width: 100%;
      margin-bottom: 10px;
    }
    
    .results-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
      padding: 20px;
      background: white;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }
    
    .results-count {
      font-size: 1.1rem;
      font-weight: 600;
      color: #1a1a1a;
      font-family: 'Be Vietnam Pro', sans-serif;
    }
    
    .sort-options {
      display: flex;
      align-items: center;
      gap: 10px;
    }
    
    .sort-options label {
      font-weight: 600;
      color: #555;
      font-family: 'Be Vietnam Pro', sans-serif;
    }
    
    .sort-options select {
      padding: 8px 15px;
      border: 1px solid #ddd;
      border-radius: 6px;
      font-size: 0.95rem;
      cursor: pointer;
      outline: none;
      font-family: 'Be Vietnam Pro', sans-serif;
    }
    
    .no-results {
      text-align: center;
      padding: 60px 20px;
    }
    
    .no-results-icon {
      font-size: 60px;
      margin-bottom: 20px;
    }
    
    .no-results h2 {
      color: #555;
      margin-bottom: 10px;
    }
    
    .no-results p {
      color: #999;
    }
    
    @media (max-width: 768px) {
      .search-layout {
        grid-template-columns: 1fr;
      }
      
      .search-sidebar {
        position: static;
      }
      
      .results-header {
        flex-direction: column;
        gap: 15px;
        text-align: center;
      }
    }
  </style>
</head>
<body>
  <%@ include file="/includes/header.jsp" %>

  <main class="container" style="padding-top: 100px; padding-bottom: 60px;">
    <!-- Search Header -->
    <div class="search-header">
      <h1 class="page-title">🔍 Tìm kiếm khóa học</h1>
      
      <!-- Search Bar -->
      <form class="search-form" method="get" action="${pageContext.request.contextPath}/search.jsp">
        <div class="search-input-wrapper">
          <input type="text" name="q" placeholder="Nhập tên khóa học, chủ đề..." value="<%= keyword %>" class="search-input" />
          <button type="submit" class="search-btn">Tìm kiếm</button>
        </div>
        <input type="hidden" name="category" value="<%= category %>" id="hiddenCategory" />
        <input type="hidden" name="price" value="<%= priceRange %>" id="hiddenPrice" />
        <input type="hidden" name="sort" value="<%= sortBy %>" id="hiddenSort" />
      </form>
    </div>

    <!-- Filters & Results -->
    <div class="search-layout">
      <!-- Sidebar Filters -->
      <aside class="search-sidebar">
        <div class="filter-section">
          <h3 class="filter-title">📂 Danh mục</h3>
          <div class="filter-options">
            <label class="filter-option">
              <input type="radio" name="category" value="all" <%= "all".equals(category) ? "checked" : "" %> onchange="applyFilters()" />
              <span>Tất cả</span>
            </label>
            <label class="filter-option">
              <input type="radio" name="category" value="python" <%= "python".equals(category) ? "checked" : "" %> onchange="applyFilters()" />
              <span>Lập trình - CNTT</span>
            </label>
            <label class="filter-option">
              <input type="radio" name="category" value="finance" <%= "finance".equals(category) ? "checked" : "" %> onchange="applyFilters()" />
              <span>Tài chính</span>
            </label>
            <label class="filter-option">
              <input type="radio" name="category" value="data" <%= "data".equals(category) ? "checked" : "" %> onchange="applyFilters()" />
              <span>Data analyst</span>
            </label>
            <label class="filter-option">
              <input type="radio" name="category" value="blockchain" <%= "blockchain".equals(category) ? "checked" : "" %> onchange="applyFilters()" />
              <span>Blockchain</span>
            </label>
            <label class="filter-option">
              <input type="radio" name="category" value="accounting" <%= "accounting".equals(category) ? "checked" : "" %> onchange="applyFilters()" />
              <span>Kế toán</span>
            </label>
            <label class="filter-option">
              <input type="radio" name="category" value="marketing" <%= "marketing".equals(category) ? "checked" : "" %> onchange="applyFilters()" />
              <span>Marketing</span>
            </label>
          </div>
        </div>

        <div class="filter-section">
          <h3 class="filter-title">💰 Khoảng giá</h3>
          <div class="filter-options">
            <label class="filter-option">
              <input type="radio" name="price" value="all" <%= "all".equals(priceRange) ? "checked" : "" %> onchange="applyFilters()" />
              <span>Tất cả</span>
            </label>
            <label class="filter-option">
              <input type="radio" name="price" value="free" <%= "free".equals(priceRange) ? "checked" : "" %> onchange="applyFilters()" />
              <span>Miễn phí</span>
            </label>
            <label class="filter-option">
              <input type="radio" name="price" value="under500" <%= "under500".equals(priceRange) ? "checked" : "" %> onchange="applyFilters()" />
              <span>Dưới 500,000₫</span>
            </label>
            <label class="filter-option">
              <input type="radio" name="price" value="500to1000" <%= "500to1000".equals(priceRange) ? "checked" : "" %> onchange="applyFilters()" />
              <span>500,000₫ - 1,000,000₫</span>
            </label>
            <label class="filter-option">
              <input type="radio" name="price" value="over1000" <%= "over1000".equals(priceRange) ? "checked" : "" %> onchange="applyFilters()" />
              <span>Trên 1,000,000₫</span>
            </label>
          </div>
        </div>

        <button type="button" class="btn btn-secondary btn-block" onclick="clearFilters()">🔄 Xóa bộ lọc</button>
      </aside>

      <!-- Results -->
      <div class="search-results">
        <div class="results-header">
          <p class="results-count">
            <% if (!keyword.isEmpty()) { %>
              Tìm thấy <strong><%= courses.size() %></strong> khóa học cho "<%= keyword %>"
            <% } else { %>
              Hiển thị <strong><%= courses.size() %></strong> khóa học
            <% } %>
          </p>
          <div class="sort-options">
            <label for="sortSelect">Sắp xếp:</label>
            <select id="sortSelect" onchange="applySorting(this.value)">
              <option value="newest" <%= "newest".equals(sortBy) ? "selected" : "" %>>Mới nhất</option>
              <option value="price-asc" <%= "price-asc".equals(sortBy) ? "selected" : "" %>>Giá thấp → cao</option>
              <option value="price-desc" <%= "price-desc".equals(sortBy) ? "selected" : "" %>>Giá cao → thấp</option>
              <option value="popular" <%= "popular".equals(sortBy) ? "selected" : "" %>>Phổ biến nhất</option>
            </select>
          </div>
        </div>

        <% if (courses.isEmpty()) { %>
          <div class="no-results">
            <div class="no-results-icon">🔍</div>
            <h2>Không tìm thấy khóa học</h2>
            <p>Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm</p>
          </div>
        <% } else { %>
          <div class="grid grid-3">
            <% for (Course course : courses) { %>
              <article class="course-card">
                <% if (course.isNew()) { %>
                  <span class="badge badge-new">MỚI</span>
                <% } %>
                <% if (course.getDiscountPercentage() > 0) { %>
                  <span class="badge badge-discount">-<%= course.getDiscountPercentage() %>%</span>
                <% } %>
                <figure class="card-thumb">
                  <img src="${pageContext.request.contextPath}/<%= course.getThumbnail() %>" alt="<%= course.getCourseName() %>" loading="lazy" />
                </figure>
                <div class="card-body">
                  <span class="card-category"><%= course.getCategory() %></span>
                  <h3 class="card-title"><%= course.getCourseName() %></h3>
                  <p class="card-desc"><%= course.getDescription() %></p>
                  <div class="card-meta">
                    <span>⏱️ <%= course.getDuration() %></span>
                    <span>👥 <%= course.getStudentsCount() %> học viên</span>
                    <span>📊 <%= course.getLevel() %></span>
                  </div>
                  <div class="card-footer">
                    <div class="price-box">
                      <% if (course.getOldPrice() != null && course.getOldPrice().compareTo(course.getPrice()) > 0) { %>
                        <span class="price-old"><%= String.format("%,d", course.getOldPrice().longValue()) %>₫</span>
                      <% } %>
                      <span class="price-current"><%= String.format("%,d", course.getPrice().longValue()) %>₫</span>
                    </div>
                    <button class="btn btn-add-cart" onclick="addToCart('<%= course.getCourseId() %>', '<%= course.getCourseName() %>', <%= course.getPrice().longValue() %>)">
                      🛒 Thêm vào giỏ
                    </button>
                  </div>
                </div>
              </article>
            <% } %>
          </div>
        <% } %>
      </div>
    </div>
  </main>

  <%@ include file="/includes/footer.jsp" %>

  <script src="${pageContext.request.contextPath}/assets/js/cart.js"></script>
  <script>
    // Apply filters
    function applyFilters() {
      const category = document.querySelector('input[name="category"]:checked').value;
      const price = document.querySelector('input[name="price"]:checked').value;
      const sort = document.getElementById('sortSelect').value;
      const keyword = document.querySelector('.search-input').value;

      const baseUrl = '${pageContext.request.contextPath}/search.jsp';
      window.location.href = baseUrl + '?q=' + encodeURIComponent(keyword) + '&category=' + category + '&price=' + price + '&sort=' + sort;
    }

    // Clear filters
    function clearFilters() {
      window.location.href = '${pageContext.request.contextPath}/search.jsp';
    }

    // Apply sorting
    function applySorting(sortValue) {
      const category = document.querySelector('input[name="category"]:checked').value;
      const price = document.querySelector('input[name="price"]:checked').value;
      const keyword = document.querySelector('.search-input').value;

      const baseUrl = '${pageContext.request.contextPath}/search.jsp';
      window.location.href = baseUrl + '?q=' + encodeURIComponent(keyword) + '&category=' + category + '&price=' + price + '&sort=' + sortValue;
    }
  </script>

  <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/cart.js"></script>
</body>
</html>
