<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
    String userEmail = (String) session.getAttribute("userEmail");
    String userPhone = (String) session.getAttribute("userPhone");
    String userFullname = (String) session.getAttribute("userFullname");
    String successMessage = (String) session.getAttribute("successMessage");
    
    // Clear success message after displaying
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
    
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
  <title>PTIT LEARNING by FIN1</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
</head>
<body>
  <%@ include file="/includes/header.jsp" %>

  <section class="hero">
    <video class="hero-bg" autoplay loop muted playsinline>
      <source src="${pageContext.request.contextPath}/assets/img/Index/12676758_3840_2160_30fps.mp4" type="video/mp4" />
      <!-- Fallback image if video doesn't load -->
      <img src="${pageContext.request.contextPath}/assets/img/hero.jpg" alt="Nền học tập" />
    </video>
    <div class="container hero-inner">
      <h1>Phát triển và nâng cao kỹ năng của bạn</h1>
      <p>Khám phá các chiến lược tiên tiến để tối ưu hóa quá trình học tập, nâng cao kỹ năng và đạt được thành công nhanh chóng trong sự nghiệp.</p>
      <% if (loggedIn != null && loggedIn) { %>
        <a class="btn btn-primary" href="#combos">Bắt đầu</a>
      <% } else { %>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/signup.jsp">Bắt đầu</a>
      <% } %>
    </div>
  </section>

  <section class="section" id="combos">
    <div class="container">
      <h2 class="section-title">Combo tiết kiệm học tập</h2>
      <p class="section-sub">Một bộ khóa học chất lượng cao với mức giá ưu đãi, giúp bạn tiết kiệm chi phí và tận dụng tối đa thời gian học tập.</p>
      <div class="grid grid-3">
        <a href="${pageContext.request.contextPath}/courses-python.jsp" class="card card-link">
          <img src="${pageContext.request.contextPath}/assets/img/Index/combo sv lập trình.png" alt="Combo sinh viên lập trình" class="card-img" />
          <div class="card-body">
            <h3 class="card-title">Combo sinh viên lập trình</h3>
            <p class="card-text">Bộ combo dành cho sinh viên lập trình với các khóa học từ cơ bản đến nâng cao.</p>
          </div>
        </a>
        <a href="${pageContext.request.contextPath}/courses-finance.jsp" class="card card-link">
          <img src="${pageContext.request.contextPath}/assets/img/Index/combo sv kinh tế.png" alt="Combo sinh viên kinh tế" class="card-img" />
          <div class="card-body">
            <h3 class="card-title">Combo sinh viên kinh tế</h3>
            <p class="card-text">Combo học tập toàn diện cho sinh viên ngành kinh tế và quản trị.</p>
          </div>
        </a>
        <a href="${pageContext.request.contextPath}/courses-accounting.jsp" class="card card-link">
          <img src="${pageContext.request.contextPath}/assets/img/Index/kế toàn cơ bản.png" alt="Combo kế toán cơ bản" class="card-img" />
          <div class="card-body">
            <h3 class="card-title">Kế toán cơ bản</h3>
            <p class="card-text">Khóa học kế toán từ cơ bản giúp bạn nắm vững kiến thức nền tảng.</p>
          </div>
        </a>
      </div>
      <% if (loggedIn == null || !loggedIn) { %>
        <div style="text-align:center;margin-top:48px">
          <a class="btn btn-primary" style="padding:16px 48px;font-size:18px" href="${pageContext.request.contextPath}/signup.jsp">Đăng ký ngay</a>
        </div>
      <% } %>
    </div>
  </section>

  <section class="feature-banner">
    <video class="feature-video-bg" autoplay loop muted playsinline>
      <source src="${pageContext.request.contextPath}/assets/img/Index/phat trien ky nang light.mp4" type="video/mp4" />
    </video>
    <div class="feature-overlay"></div>
    <div class="container feature-inner">
      <div>
        <h3 class="feature-title">Dành cho bạn</h3>
        <ul class="feature-list">
          <li>Tiết kiệm chi phí đáng kể</li>
          <li>Lộ trình học tập toàn diện</li>
          <li>Lịch trình linh hoạt</li>
          <li>Cơ hội nhận quà tặng thưởng</li>
        </ul>
      </div>
    </div>
  </section>

  <section class="section" id="courses">
    <div class="container">
      <h2 class="section-title">Các khóa học phổ biến nhất</h2>
      <div class="grid grid-2">
        <a href="${pageContext.request.contextPath}/courses-python.jsp" class="card card-wide card-link">
          <img src="${pageContext.request.contextPath}/assets/img/Index/python.png" alt="Khóa học Python" class="card-img" />
          <div class="card-body">
            <h3 class="card-title">Lập trình Python</h3>
            <p class="card-text">Học Python từ cơ bản đến nâng cao, xây dựng ứng dụng web và phân tích dữ liệu.</p>
          </div>
        </a>
        <a href="${pageContext.request.contextPath}/courses-blockchain.jsp" class="card card-wide card-link">
          <img src="${pageContext.request.contextPath}/assets/img/Index/blockchian.png" alt="Khóa học Blockchain" class="card-img" />
          <div class="card-body">
            <h3 class="card-title">Blockchain & Crypto</h3>
            <p class="card-text">Tìm hiểu công nghệ Blockchain, Smart Contract và ứng dụng trong thực tế.</p>
          </div>
        </a>
      </div>
    </div>
  </section>

  <section class="section" id="testimonials">
    <div class="container">
      <h2 class="section-title">Phản hồi của sinh viên</h2>
      <div class="grid grid-3 cards-compact">
        <article class="quote">
          <p class="quote-text">"Khóa học Python rất chi tiết và dễ hiểu. Nhờ nền tảng này mà mình đã nhận được offer thực tập!"</p>
          <div class="avatar">
            <img src="${pageContext.request.contextPath}/assets/img/Index/548783684_1361425655344265_495483220803173616_n.jpg" alt="Nguyễn Tiến Hải" />
            <div class="meta">
              <span class="name">Nguyễn Tiến Hải</span>
              <span class="desc">Sinh viên CNTT - K67</span>
            </div>
          </div>
        </article>
        <article class="quote">
          <p class="quote-text">"Chất lượng giảng dạy tốt, tài liệu đầy đủ. Combo Kế toán - Tài chính giúp mình vững kiến thức!"</p>
          <div class="avatar">
            <img src="${pageContext.request.contextPath}/assets/img/Index/518372267_2191281887968019_3789860291768466048_n.jpg" alt="Đinh Thị Thu Hà" />
            <div class="meta">
              <span class="name">Đinh Thị Thu Hà</span>
              <span class="desc">Sinh viên Kế toán - K66</span>
            </div>
          </div>
        </article>
        <article class="quote">
          <p class="quote-text">"Nền tảng tuyệt vời với video bài giảng rõ ràng. Kiến thức rất bổ ích cho công việc!"</p>
          <div class="avatar">
            <img src="${pageContext.request.contextPath}/assets/img/Index/50853113_1192888007544710_6452615284753694720_n.jpg" alt="Hà Linh Nhi" />
            <div class="meta">
              <span class="name">Hà Linh Nhi</span>
              <span class="desc">Sinh viên Khoa học dữ liệu - K65</span>
            </div>
          </div>
        </article>
      </div>
      <% if (loggedIn == null || !loggedIn) { %>
        <a class="btn btn-primary mt-24" href="${pageContext.request.contextPath}/signup.jsp">Đăng ký</a>
      <% } %>
    </div>
  </section>

  <section class="cta">
    <div class="container cta-inner">
      <h3>PTIT LEARNING by FIN1</h3>
      <% if (loggedIn == null || !loggedIn) { %>
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/signup.jsp">Đăng ký tài khoản</a>
      <% } %>
    </div>
  </section>

  <%@ include file="/includes/footer.jsp" %>

  <script>
    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
      anchor.addEventListener('click', function (e) {
        const href = this.getAttribute('href');
        if (href !== '#' && href.length > 1) {
          const target = document.querySelector(href);
          if (target) {
            e.preventDefault();
            target.scrollIntoView({
              behavior: 'smooth',
              block: 'start'
            });
          }
        }
      });
    });
  </script>
  
  <% if (successMessage != null) { %>
  <script>
    window.addEventListener('DOMContentLoaded', function() {
      // Create popup overlay
      const overlay = document.createElement('div');
      overlay.style.cssText = 'position:fixed;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.5);z-index:9999;display:flex;align-items:center;justify-content:center;';
      
      // Create popup
      const popup = document.createElement('div');
      popup.style.cssText = 'background:white;padding:40px;border-radius:12px;box-shadow:0 10px 40px rgba(0,0,0,0.3);max-width:400px;text-align:center;animation:slideIn 0.3s ease-out;';
      
      // Add checkmark icon
      const icon = document.createElement('div');
      icon.innerHTML = '✓';
      icon.style.cssText = 'width:60px;height:60px;background:#4CAF50;color:white;font-size:40px;line-height:60px;border-radius:50%;margin:0 auto 20px;';
      
      // Add message
      const message = document.createElement('p');
      message.textContent = '<%= successMessage %>';
      message.style.cssText = 'font-size:18px;color:#333;margin:0;line-height:1.5;';
      
      popup.appendChild(icon);
      popup.appendChild(message);
      overlay.appendChild(popup);
      document.body.appendChild(overlay);
      
      // Auto close after 3 seconds
      setTimeout(function() {
        overlay.style.opacity = '0';
        overlay.style.transition = 'opacity 0.3s';
        setTimeout(function() {
          document.body.removeChild(overlay);
        }, 300);
      }, 3000);
      
      // Close on click
      overlay.addEventListener('click', function() {
        document.body.removeChild(overlay);
      });
    });
  </script>
  <% } %>

  <!-- Scripts -->
  <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
  <script src="${pageContext.request.contextPath}/assets/js/cart.js"></script>
</body>
</html>

