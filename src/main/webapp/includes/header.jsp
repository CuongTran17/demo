<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.dao.CartDAO" %>
<%
    // Get session attributes for header
    Boolean headerLoggedIn = (Boolean) session.getAttribute("loggedIn");
    String headerUserEmail = (String) session.getAttribute("userEmail");
    String headerUserPhone = (String) session.getAttribute("userPhone");
    Integer headerUserId = (Integer) session.getAttribute("userId");
    
    String headerDisplayInfo = "";
    int cartCount = 0;
    
    if (headerLoggedIn != null && headerLoggedIn) {
        if (headerUserPhone != null && headerUserPhone.length() >= 3) {
            headerDisplayInfo = "***" + headerUserPhone.substring(headerUserPhone.length() - 3);
        } else if (headerUserEmail != null) {
            headerDisplayInfo = headerUserEmail;
        }
        
        // Get cart count from database
        if (headerUserId != null) {
            try {
                CartDAO headerCartDAO = new CartDAO();
                cartCount = headerCartDAO.getCartCount(headerUserId);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
%>
<!-- Header -->
<header class="topbar">
  <div class="container nav">
    <a class="brand" href="${pageContext.request.contextPath}/">PTIT <strong>LEARNING</strong> <span class="by">by FIN1</span></a>
    
    <button class="hamburger" id="hamburger" aria-label="Mở menu" aria-expanded="false">
      <span></span><span></span><span></span>
    </button>
    
    <!-- Search Box in Header -->
    <form action="${pageContext.request.contextPath}/search.jsp" method="get" class="header-search-form">
      <input 
        type="text" 
        name="q" 
        class="header-search-input" 
        placeholder="Tìm kiếm..."
        aria-label="Tìm kiếm khóa học"
      />
      <button type="submit" class="header-search-btn" aria-label="Tìm kiếm">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <circle cx="11" cy="11" r="8"></circle>
          <path d="m21 21-4.35-4.35"></path>
        </svg>
      </button>
    </form>
    
    <nav class="menu" aria-label="Chính">
      <!-- Mobile Search -->
      <form action="${pageContext.request.contextPath}/search.jsp" method="get" class="mobile-search-form">
        <input 
          type="text" 
          name="q" 
          class="mobile-search-input" 
          placeholder="Tìm kiếm khóa học..."
          aria-label="Tìm kiếm khóa học"
        />
        <button type="submit" class="mobile-search-btn" aria-label="Tìm kiếm">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="11" cy="11" r="8"></circle>
            <path d="m21 21-4.35-4.35"></path>
          </svg>
        </button>
      </form>
      
      <div class="dropdown">
        <a href="javascript:void(0)" class="has-dd" id="coursesMenu" aria-haspopup="true" aria-expanded="false">Các khóa học</a>
        <div class="dd" role="menu" aria-labelledby="coursesMenu">
          <div class="dd-inner">
            <div class="dd-head">Tất cả các khóa học</div>
            <div class="dd-grid">
              <a href="${pageContext.request.contextPath}/courses?category=python">Lập trình - CNTT</a>
              <a href="${pageContext.request.contextPath}/courses?category=finance">Tài chính</a>
              <a href="${pageContext.request.contextPath}/courses?category=data">Data analyst</a>
              <a href="${pageContext.request.contextPath}/courses?category=blockchain">Blockchain</a>
              <a href="${pageContext.request.contextPath}/courses?category=accounting">Kế toán</a>
              <a href="${pageContext.request.contextPath}/courses?category=marketing">Marketing</a>
            </div>
          </div>
        </div>
      </div>
      <a href="${pageContext.request.contextPath}/blog.jsp">Blog</a>
      <a href="${pageContext.request.contextPath}/contact.jsp">Liên hệ</a>
      <a href="${pageContext.request.contextPath}/cart" class="cart-link">
        Giỏ hàng
        <% if (cartCount > 0) { %>
          <span class="cart-badge"><%= cartCount %></span>
        <% } %>
      </a>
      <% if (headerLoggedIn != null && headerLoggedIn) { %>
        <a href="${pageContext.request.contextPath}/account" class="user-info"><%= headerDisplayInfo %></a>
      <% } else { %>
        <a href="${pageContext.request.contextPath}/login.jsp">Đăng nhập/Đăng ký</a>
      <% } %>
    </nav>
  </div>
</header>
