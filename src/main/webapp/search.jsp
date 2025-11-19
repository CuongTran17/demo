<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.model.Course" %>
<%@ page import="com.example.dao.CourseDAO" %>
<% response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
    
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
    List<Course> courses = courseDAO.searchCourses(keyword, category, priceRange, sortBy); %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="UTF-8" />
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <title>Tìm kiếm khóa học – PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/search.css" />
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
          <div class="search-grid">
            <% for (Course course : courses) { %>
              <article class="search-course-card">
                <div class="search-card-image">
                  <% String thumbnailPath = course.getThumbnail();
                    if (thumbnailPath == null || thumbnailPath.isEmpty()) {
                      // Default image based on category and course ID - khớp với courses pages
                      switch(course.getCategory()) {
                        case "python":
                          switch(course.getCourseId()) {
                            case "python-basics":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-python/Python Basics.png";
                              break;
                            case "python-complete":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-python/Python.png";
                              break;
                            case "python-excel":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-python/Python Excel.png";
                              break;
                            case "selenium-python":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-python/Selenium Python.png";
                              break;
                            case "python-oop":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-python/Python OOP.png";
                              break;
                            case "python-procedural":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-python/Procedural Python.png";
                              break;
                            default:
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-python/Python Basics.png";
                          }
                          break;
                        case "finance":
                          switch(course.getCourseId()) {
                            case "finance-basic":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-finance/Tài chính cơ bản.png";
                              break;
                            case "investment":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-finance/Đầu tư chứng khoán.png";
                              break;
                            case "banking":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-finance/Ngân hàng.png";
                              break;
                            case "personal-finance":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-finance/Tài chính cá nhân.png";
                              break;
                            case "forex":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-finance/Forex.png";
                              break;
                            case "financial-analysis":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-finance/Phân tích tài chính.png";
                              break;
                            default:
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-finance/Tài chính cơ bản.png";
                          }
                          break;
                        case "data":
                          switch(course.getCourseId()) {
                            case "data-basic":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-data/Data Analytics cơ bản.png";
                              break;
                            case "excel-data":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-data/Excel for Data.png";
                              break;
                            case "sql-data":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-data/SQL.png";
                              break;
                            case "power-bi":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-data/Power BI.png";
                              break;
                            case "python-data":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-data/Python for Data.png";
                              break;
                            case "tableau":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-data/Tableau.png";
                              break;
                            default:
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-data/Data Analytics cơ bản.png";
                          }
                          break;
                        case "blockchain":
                          switch(course.getCourseId()) {
                            case "blockchain-basic":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-blockchain/Blockchain cơ bản.png";
                              break;
                            case "smart-contract":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-blockchain/Smart Contract.png";
                              break;
                            case "defi":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-blockchain/DeFi.png";
                              break;
                            case "ethereum":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-blockchain/Ethereum.png";
                              break;
                            case "nft":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-blockchain/NFT.png";
                              break;
                            case "crypto-trading":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-blockchain/Crypto Trading.png";
                              break;
                            default:
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-blockchain/Blockchain cơ bản.png";
                          }
                          break;
                        case "accounting":
                          switch(course.getCourseId()) {
                            case "accounting-basic":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-accounting/Kế toán cơ bản.png";
                              break;
                            case "accounting-intermediate":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-accounting/Kế toán trung cấp.png";
                              break;
                            case "accounting-tax":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-accounting/Kế toán thuế.png";
                              break;
                            case "audit":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-accounting/Kiểm toán.png";
                              break;
                            case "excel-accounting":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-accounting/Excel kế toán.png";
                              break;
                            default:
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-accounting/Kế toán cơ bản.png";
                          }
                          break;
                        case "marketing":
                          switch(course.getCourseId()) {
                            case "marketing-basic":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-marketing/Marketing cơ bản.png";
                              break;
                            case "digital-marketing":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-marketing/Digital Marketing.png";
                              break;
                            case "facebook-ads":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-marketing/Facebook Ads.png";
                              break;
                            case "google-ads":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-marketing/Google Ads.png";
                              break;
                            case "content-marketing":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-marketing/Content Marketing.png";
                              break;
                            case "social-media":
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-marketing/Social Media.png";
                              break;
                            default:
                              thumbnailPath = "" + request.getContextPath() + "/assets/img/courses-marketing/Marketing cơ bản.png";
                          }
                          break;
                        default:
                          thumbnailPath = "" + request.getContextPath() + "/assets/img/Index/combo sv kinh tế.png";
                      }
                    } %>
                  <img src="<%= thumbnailPath %>" alt="<%= course.getCourseName() %>" loading="lazy" />
                  
                  <div class="search-card-badges">
                    <% if (course.isNew()) { %>
                      <span class="search-badge new">MỚI</span>
                    <% } %>
                    <% if (course.getDiscountPercentage() > 0) { %>
                      <span class="search-badge discount">-<%= course.getDiscountPercentage() %>%</span>
                    <% } %>
                  </div>
                </div>
                
                <div class="search-card-content">
                  <span class="search-card-category">
                    <% String categoryDisplay = "";
                      switch(course.getCategory()) {
                        case "python": categoryDisplay = "Lập trình - CNTT"; break;
                        case "finance": categoryDisplay = "Tài chính"; break;
                        case "data": categoryDisplay = "Data Analyst"; break;
                        case "blockchain": categoryDisplay = "Blockchain"; break;
                        case "accounting": categoryDisplay = "Kế toán"; break;
                        case "marketing": categoryDisplay = "Marketing"; break;
                        default: categoryDisplay = course.getCategory();
                      } %>
                    <%= categoryDisplay %>
                  </span>
                  
                  <h3 class="search-card-title"><%= course.getCourseName() %></h3>
                  
                  <p class="search-card-description">
                    <%= course.getDescription() != null ? course.getDescription() : "Khóa học chất lượng cao với nội dung cập nhật và thực tế, giúp bạn nâng cao kỹ năng chuyên môn." %>
                  </p>
                  
                  <div class="search-card-meta">
                    <span>⏱️ <%= course.getDuration() != null ? course.getDuration() : "16 giờ" %></span>
                    <span>👥 <%= String.format("%,d", course.getStudentsCount()) %> học viên</span>
                    <span>📊 <%= course.getLevel() != null ? course.getLevel() : "All" %></span>
                    <span>⭐ 4.8 (Reviews)</span>
                  </div>
                  
                  <div class="search-card-footer">
                    <div class="search-price-box">
                      <% if (course.getOldPrice() != null && course.getOldPrice().compareTo(course.getPrice()) > 0) { %>
                        <span class="search-price-old"><%= String.format("%,d", course.getOldPrice().longValue()) %>₫</span>
                      <% } %>
                      <span class="search-price-current"><%= String.format("%,d", course.getPrice().longValue()) %>₫</span>
                    </div>
                    <button class="search-add-cart" onclick="addToCart('<%= course.getCourseId() %>', '<%= course.getCourseName() %>', <%= course.getPrice().longValue() %>)">
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

  <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/cart.js"></script>
  <script>
    // Get context path for URLs
    const contextPath = '<%= request.getContextPath() %>';

    // Apply filters
    function applyFilters() {
      const category = document.querySelector('input[name="category"]:checked').value;
      const price = document.querySelector('input[name="price"]:checked').value;
      const sort = document.getElementById('sortSelect').value;
      const keyword = document.querySelector('.search-input').value;

      const baseUrl = contextPath + '/search.jsp';
      window.location.href = baseUrl + '?q=' + encodeURIComponent(keyword) + '&category=' + category + '&price=' + price + '&sort=' + sort;
    }

    // Clear filters
    function clearFilters() {
      window.location.href = contextPath + '/search.jsp';
    }

    // Apply sorting
    function applySorting(sortValue) {
      const category = document.querySelector('input[name="category"]:checked').value;
      const price = document.querySelector('input[name="price"]:checked').value;
      const keyword = document.querySelector('.search-input').value;

      const baseUrl = contextPath + '/search.jsp';
      window.location.href = baseUrl + '?q=' + encodeURIComponent(keyword) + '&category=' + category + '&price=' + price + '&sort=' + sortValue;
    }
  </script>
</body>
</html>
