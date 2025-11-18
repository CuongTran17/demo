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
  <meta charset="UTF-8" />
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <title>Tìm kiếm khóa học – PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="/assets/css/styles.css" />
  <style>
    /* Search Page Specific Styles */
    * {
      font-family: 'Be Vietnam Pro', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
    }
    
    body {
      font-family: 'Be Vietnam Pro', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      font-feature-settings: "kern" 1;
      text-rendering: optimizeLegibility;
      -webkit-text-size-adjust: 100%;
      -ms-text-size-adjust: 100%;
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
      font-weight: 700;
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
    
    /* Course Cards Specific Styles */
    .search-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
      gap: 25px;
      margin-top: 20px;
    }
    
    .search-course-card {
      background: white;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 2px 15px rgba(0,0,0,0.08);
      transition: transform 0.3s, box-shadow 0.3s;
      display: flex;
      flex-direction: column;
      height: 100%;
    }
    
    .search-course-card:hover {
      transform: translateY(-4px);
      box-shadow: 0 8px 25px rgba(0,0,0,0.12);
    }
    
    .search-card-image {
      position: relative;
      height: 200px;
      overflow: hidden;
    }
    
    .search-card-image img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      transition: transform 0.3s;
    }
    
    .search-course-card:hover .search-card-image img {
      transform: scale(1.05);
    }
    
    .search-card-badges {
      position: absolute;
      top: 12px;
      left: 12px;
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
    }
    
    .search-badge {
      padding: 4px 10px;
      border-radius: 20px;
      font-size: 0.75rem;
      font-weight: 600;
      color: white;
      text-transform: uppercase;
    }
    
    .search-badge.new {
      background: linear-gradient(45deg, #ff6b6b, #ffd93d);
    }
    
    .search-badge.discount {
      background: linear-gradient(45deg, #ff6b6b, #ff8e53);
    }
    
    .search-card-content {
      padding: 20px;
      flex: 1;
      display: flex;
      flex-direction: column;
    }
    
    .search-card-category {
      display: inline-block;
      background: #f1f3f4;
      color: #666;
      padding: 4px 12px;
      border-radius: 15px;
      font-size: 0.75rem;
      font-weight: 500;
      margin-bottom: 12px;
      width: fit-content;
    }
    
    .search-card-title {
      font-size: 1.1rem;
      font-weight: 700;
      color: #1a1a1a;
      margin-bottom: 8px;
      line-height: 1.4;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }
    
    .search-card-description {
      color: #666;
      font-size: 0.9rem;
      line-height: 1.5;
      margin-bottom: 15px;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
      flex: 1;
    }
    
    .search-card-meta {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 8px;
      margin-bottom: 15px;
      font-size: 0.8rem;
      color: #666;
    }
    
    .search-card-meta span {
      display: flex;
      align-items: center;
      gap: 4px;
    }
    
    .search-card-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: auto;
    }
    
    .search-price-box {
      display: flex;
      flex-direction: column;
      align-items: flex-start;
    }
    
    .search-price-old {
      color: #999;
      text-decoration: line-through;
      font-size: 0.8rem;
      margin-bottom: 2px;
    }
    
    .search-price-current {
      color: #667eea;
      font-weight: 700;
      font-size: 1.1rem;
    }
    
    .search-add-cart {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      border: none;
      padding: 10px 16px;
      border-radius: 8px;
      font-size: 0.85rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s;
      white-space: nowrap;
    }
    
    .search-add-cart:hover {
      background: linear-gradient(135deg, #5a67d8 0%, #6c5ce7 100%);
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
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
      
      .search-grid {
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 20px;
      }
      
      .search-card-meta {
        grid-template-columns: 1fr;
      }
      
      .search-card-footer {
        flex-direction: column;
        gap: 10px;
      }
      
      .search-add-cart {
        width: 100%;
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
      <form class="search-form" method="get" action="/search.jsp">
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
                  <% 
                    String thumbnailPath = course.getThumbnail();
                    if (thumbnailPath == null || thumbnailPath.isEmpty()) {
                      // Default image based on category and course ID using actual files
                      switch(course.getCategory()) {
                        case "python":
                          switch(course.getCourseId()) {
                            case "python-basics":
                              thumbnailPath = "/assets/img/courses-python/Python Basics.png";
                              break;
                            case "python-complete":
                              thumbnailPath = "/assets/img/courses-python/Python.png";
                              break;
                            case "python-excel":
                              thumbnailPath = "/assets/img/courses-python/Python Excel.png";
                              break;
                            case "selenium-python":
                              thumbnailPath = "/assets/img/courses-python/Selenium Python.png";
                              break;
                            case "python-oop":
                              thumbnailPath = "/assets/img/courses-python/Python OOP.png";
                              break;
                            default:
                              thumbnailPath = "/assets/img/courses-python/Python Basics.png";
                          }
                          break;
                        case "finance":
                          switch(course.getCourseId()) {
                            case "finance-basic":
                              thumbnailPath = "/assets/img/courses-finance/Tài chính cơ bản.png";
                              break;
                            case "investment":
                              thumbnailPath = "/assets/img/courses-finance/Đầu tư chứng khoán.png";
                              break;
                            case "banking":
                              thumbnailPath = "/assets/img/courses-finance/Ngân hàng.png";
                              break;
                            case "personal-finance":
                              thumbnailPath = "/assets/img/courses-finance/Tài chính cá nhân.png";
                              break;
                            case "forex":
                              thumbnailPath = "/assets/img/courses-finance/Forex.png";
                              break;
                            case "financial-analysis":
                              thumbnailPath = "/assets/img/courses-finance/Phân tích tài chính.png";
                              break;
                            default:
                              thumbnailPath = "/assets/img/courses-finance/Tài chính cơ bản.png";
                          }
                          break;
                        case "data":
                          switch(course.getCourseId()) {
                            case "data-basic":
                              thumbnailPath = "/assets/img/courses-data/Data Analytics cơ bản.png";
                              break;
                            case "excel-data":
                              thumbnailPath = "/assets/img/courses-data/Excel for Data.png";
                              break;
                            case "sql-data":
                              thumbnailPath = "/assets/img/courses-data/SQL.png";
                              break;
                            case "power-bi":
                              thumbnailPath = "/assets/img/courses-data/Power BI.png";
                              break;
                            case "python-data":
                              thumbnailPath = "/assets/img/courses-data/Python for Data.png";
                              break;
                            case "tableau":
                              thumbnailPath = "/assets/img/courses-data/Tableau.png";
                              break;
                            default:
                              thumbnailPath = "/assets/img/courses-data/Data Analytics cơ bản.png";
                          }
                          break;
                        case "blockchain":
                          switch(course.getCourseId()) {
                            case "blockchain-basic":
                              thumbnailPath = "/assets/img/courses-blockchain/Blockchain cơ bản.png";
                              break;
                            case "smart-contract":
                              thumbnailPath = "/assets/img/courses-blockchain/Smart Contract.png";
                              break;
                            case "defi":
                              thumbnailPath = "/assets/img/courses-blockchain/DeFi.png";
                              break;
                            case "nft":
                              thumbnailPath = "/assets/img/courses-blockchain/NFT.png";
                              break;
                            case "web3":
                              thumbnailPath = "/assets/img/courses-blockchain/Web3.png";
                              break;
                            case "crypto-trading":
                              thumbnailPath = "/assets/img/courses-blockchain/Crypto Trading.png";
                              break;
                            default:
                              thumbnailPath = "/assets/img/courses-blockchain/Blockchain cơ bản.png";
                          }
                          break;
                        case "accounting":
                          switch(course.getCourseId()) {
                            case "accounting-basic":
                              thumbnailPath = "/assets/img/courses-accounting/Kế toàn cơ bản.png";
                              break;
                            case "cost-accounting":
                              thumbnailPath = "/assets/img/courses-accounting/Kế toàn chi phí.png";
                              break;
                            case "financial-report":
                              thumbnailPath = "/assets/img/courses-accounting/Báo cáo tài chính.png";
                              break;
                            case "tax-accounting":
                              thumbnailPath = "/assets/img/courses-accounting/Kế toàn thuế.png";
                              break;
                            case "excel-accounting":
                              thumbnailPath = "/assets/img/courses-accounting/Excel kế toán.png";
                              break;
                            case "financial-statements":
                              thumbnailPath = "/assets/img/courses-accounting/Báo cáo tài chính.png";
                              break;
                            case "accounting-misa":
                              thumbnailPath = "/assets/img/courses-accounting/MISA.png";
                              break;
                            default:
                              thumbnailPath = "/assets/img/courses-accounting/Kế toàn cơ bản.png";
                          }
                          break;
                        case "marketing":
                          switch(course.getCourseId()) {
                            case "digital-marketing":
                              thumbnailPath = "/assets/img/courses-marketing/Digital Marketing.png";
                              break;
                            case "facebook-ads":
                              thumbnailPath = "/assets/img/courses-marketing/Facebook Ads.png";
                              break;
                            case "google-ads":
                              thumbnailPath = "/assets/img/courses-marketing/Google Ads.png";
                              break;
                            case "content-marketing":
                              thumbnailPath = "/assets/img/courses-marketing/Content Marketing.png";
                              break;
                            case "email-marketing":
                              thumbnailPath = "/assets/img/courses-marketing/Email Marketing.png";
                              break;
                            case "social-media":
                              thumbnailPath = "/assets/img/courses-marketing/Social Media.png";
                              break;
                            default:
                              thumbnailPath = "/assets/img/courses-marketing/Digital Marketing.png";
                          }
                          break;
                        default:
                          thumbnailPath = "/assets/img/Index/combo sv kinh tế.png";
                      }
                    } else {
                      // If thumbnail exists in db, ensure it starts with /
                      if (!thumbnailPath.startsWith("/")) {
                        thumbnailPath = "/" + thumbnailPath;
                      }
                    }
                  %>
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
                    <% 
                      String categoryDisplay = "";
                      switch(course.getCategory()) {
                        case "python": categoryDisplay = "Lập trình - CNTT"; break;
                        case "finance": categoryDisplay = "Tài chính"; break;
                        case "data": categoryDisplay = "Data Analyst"; break;
                        case "blockchain": categoryDisplay = "Blockchain"; break;
                        case "accounting": categoryDisplay = "Kế toán"; break;
                        case "marketing": categoryDisplay = "Marketing"; break;
                        default: categoryDisplay = course.getCategory();
                      }
                    %>
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

  <script src="/assets/js/cart.js"></script>
  <script>
    // Apply filters
    function applyFilters() {
      const category = document.querySelector('input[name="category"]:checked').value;
      const price = document.querySelector('input[name="price"]:checked').value;
      const sort = document.getElementById('sortSelect').value;
      const keyword = document.querySelector('.search-input').value;

      const baseUrl = '/search.jsp';
      window.location.href = baseUrl + '?q=' + encodeURIComponent(keyword) + '&category=' + category + '&price=' + price + '&sort=' + sort;
    }

    // Clear filters
    function clearFilters() {
      window.location.href = '/search.jsp';
    }

    // Apply sorting
    function applySorting(sortValue) {
      const category = document.querySelector('input[name="category"]:checked').value;
      const price = document.querySelector('input[name="price"]:checked').value;
      const keyword = document.querySelector('.search-input').value;

      const baseUrl = '/search.jsp';
      window.location.href = baseUrl + '?q=' + encodeURIComponent(keyword) + '&category=' + category + '&price=' + price + '&sort=' + sortValue;
    }
  </script>

  <script src="/assets/js/common.js"></script>
  <script src="/assets/js/cart.js"></script>
</body>
</html>
