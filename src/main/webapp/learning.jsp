<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.dao.CartDAO" %>
<%
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
    String userEmail = (String) session.getAttribute("userEmail");
    String userPhone = (String) session.getAttribute("userPhone");
    String userFullname = (String) session.getAttribute("userFullname");
    Integer userId = (Integer) session.getAttribute("userId");
    
    // Kiểm tra đăng nhập - redirect nếu chưa đăng nhập
    if (loggedIn == null || !loggedIn) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=learning");
        return;
    }
    
    String displayInfo = "";
    int cartCount = 0;
    
    if (userPhone != null && userPhone.length() >= 3) {
        displayInfo = "***" + userPhone.substring(userPhone.length() - 3);
    } else if (userEmail != null) {
        displayInfo = userEmail;
    }
    
    // Get cart count from database
    if (userId != null) {
        try {
            CartDAO cartDAO = new CartDAO();
            cartCount = cartDAO.getCartCount(userId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // Get course info from URL parameter
    String courseId = request.getParameter("course");
    if (courseId == null) {
        courseId = "finance-basic"; // Default course
    }
%>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <title>Học khóa học - PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
</head>
<body>
  <!-- Combined Header for Learning Page -->
  <header class="topbar learning-header">
    <div class="container nav learning-nav">
      <div class="learning-nav-left">
        <button class="btn-toggle-sidebar" id="toggleSidebar" aria-label="Toggle sidebar">
          <span></span>
          <span></span>
          <span></span>
        </button>
        <a class="brand" href="${pageContext.request.contextPath}/">PTIT <strong>LEARNING</strong> <span class="by">by FIN1</span></a>
      </div>
      
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
        <div class="dropdown">
          <a href="javascript:void(0)" class="has-dd" id="coursesMenu" aria-haspopup="true" aria-expanded="false">Các khóa học</a>
          <div class="dd" role="menu" aria-labelledby="coursesMenu">
            <div class="dd-inner">
              <div class="dd-head">Tất cả các khóa học</div>
              <div class="dd-grid">
                <a href="${pageContext.request.contextPath}/courses-python.jsp">Lập trình - CNTT</a>
                <a href="${pageContext.request.contextPath}/courses-finance.jsp">Tài chính</a>
                <a href="${pageContext.request.contextPath}/courses-data.jsp">Data analyst</a>
                <a href="${pageContext.request.contextPath}/courses-blockchain.jsp">Blockchain</a>
                <a href="${pageContext.request.contextPath}/courses-accounting.jsp">Kế toán</a>
                <a href="${pageContext.request.contextPath}/courses-marketing.jsp">Marketing</a>
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
        <% if (loggedIn != null && loggedIn) { %>
          <a href="${pageContext.request.contextPath}/account" class="user-info"><%= displayInfo %></a>
        <% } else { %>
          <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-sm">Đăng nhập</a>
        <% } %>
      </nav>
    </div>
    <button class="hamburger" id="hamburger" aria-label="Toggle menu" aria-expanded="false">
      <span></span>
      <span></span>
      <span></span>
    </button>
  </header>

  <div class="learning-layout">
    <!-- Sidebar -->
    <aside class="learning-sidebar" id="learningSidebar">
      <div class="sidebar-header">
        <h2 class="course-title" id="courseTitle">Lộ trình xây dựng kiến thức tài chính</h2>
        <div class="course-progress">
          <div class="progress-info">
            <span>✓ Đã hoàn thành</span>
            <span class="progress-percent" id="progressPercent">0%</span>
          </div>
          <div class="progress-bar">
            <div class="progress-fill" id="progressFill" style="width: 0%"></div>
          </div>
        </div>
      </div>

      <div class="sidebar-content">
        <div class="lessons-list" id="lessonsList">
          <!-- Lessons will be loaded here by JavaScript -->
        </div>
      </div>
    </aside>

    <!-- Main Content -->
    <main class="learning-main">
      <div class="video-container">
        <div class="video-wrapper" id="videoWrapper">
          <div id="videoPlayer"></div>
        </div>
        <div class="video-progress-info">
          <div class="progress-text">
            <span id="currentTime">0:00</span> / <span id="totalTime">0:00</span>
          </div>
          <div class="progress-bar-thin">
            <div class="progress-bar-fill" id="videoProgressBar" style="width: 0%"></div>
          </div>
        </div>
      </div>

      <!-- Lesson Info -->
      <div class="lesson-info">
        <div class="lesson-header">
          <div class="lesson-badge" id="lessonBadge">💰</div>
          <div class="lesson-details">
            <h1 class="lesson-title" id="lessonTitle">LỘ TRÌNH XÂY DỰNG KIẾN THỨC TÀI CHÍNH</h1>
            <button class="btn-copy" onclick="copyLink()" title="Sao chép đường dẫn">
              📋 Sao chép đường dẫn
            </button>
          </div>
        </div>

        <div class="lesson-tabs">
          <button class="tab-btn active" data-tab="overview">Tổng quan</button>
          <button class="tab-btn" data-tab="notes">Ghi chú</button>
          <button class="tab-btn" data-tab="qa">Hỏi đáp</button>
        </div>

        <div class="tab-content active" id="overview">
          <div class="lesson-description">
            <h3>Mô tả bài học</h3>
            <p>Khóa học <strong>"Lộ trình xây dựng kiến thức tài chính"</strong> của VNSC by Finhay sẽ giúp bạn:</p>
            <ul>
              <li>📚 Nắm vững các thuật ngữ tài chính cơ bản</li>
              <li>💹 Hiểu về thị trường tài chính và cách hoạt động</li>
              <li>💰 Học cách tích lũy và quản lý tiền bạc hiệu quả</li>
              <li>📈 Phân biệt các loại hình đầu tư: cổ phiếu, trái phiếu</li>
              <li>🎯 Xây dựng kế hoạch tài chính cá nhân từ con số 0</li>
              <li>🚀 Phát triển các cấp độ tài chính để trở thành nhà đầu tư chuyên nghiệp</li>
            </ul>
            <p>Khóa học gồm <strong>13 video</strong> với tổng thời lượng khoảng <strong>1.5 giờ</strong>, phù hợp cho người mới bắt đầu tìm hiểu về tài chính cá nhân và đầu tư.</p>
          </div>
        </div>

        <div class="tab-content" id="notes">
          <div class="notes-section">
            <h3>Ghi chú của tôi</h3>
            <textarea class="notes-textarea" placeholder="Nhập ghi chú của bạn tại đây..." rows="10"></textarea>
            <button class="btn-save-notes" onclick="saveNotes()">💾 Lưu ghi chú</button>
          </div>
        </div>

        <div class="tab-content" id="qa">
          <div class="qa-section">
            <h3>Hỏi đáp</h3>
            <div class="qa-form">
              <textarea class="qa-textarea" placeholder="Đặt câu hỏi của bạn..." rows="4"></textarea>
              <button class="btn-ask" onclick="askQuestion()">Gửi câu hỏi</button>
            </div>
            <div class="qa-list">
              <p class="empty-message">Chưa có câu hỏi nào. Hãy là người đầu tiên đặt câu hỏi!</p>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>

  <script>
    // Get course ID from URL parameter
    const urlParams = new URLSearchParams(window.location.search);
    const currentCourseId = urlParams.get('course') || 'finance-basic';
    
    // Course data for each course
    const coursesData = {
      'finance-basic': {
        title: "Tài chính cơ bản cho người mới bắt đầu",
        sections: [
          {
            title: "Phần 1: Kiến thức cơ bản",
            lessons: [
              { id: 1, title: "LỘ TRÌNH XÂY DỰNG KIẾN THỨC TÀI CHÍNH", type: "lesson", videoId: "madrRu_iU6U", duration: "3:11" },
              { id: 2, title: "BÀI 1: CÁC THUẬT NGỮ TÀI CHÍNH CƠ BẢN CẦN BIẾT", type: "lesson", videoId: "N2lvVUGtAGU", duration: "4:15" },
              { id: 3, title: "BÀI 2: HIỂU VỀ THỊ TRƯỜNG TÀI CHÍNH", type: "lesson", completed: false, videoId: "i0-K4fAvlMQ", duration: "5:03" },
              { id: 4, title: "BÀI 3: BẢN CHẤT CỦA TÍCH LŨY TIỀN BẠC", type: "lesson", completed: false, videoId: "LBxgRZ04Fvc", duration: "3:55" }
            ]
          },
          {
            title: "Phần 2: Tích lũy và đầu tư",
            lessons: [
              { id: 5, title: "BÀI 4: TÍCH LŨY TIỀN NHƯ THẾ NÀO ĐỂ ĐẠT ĐƯỢC HIỆU QUẢ NHẤT?", type: "lesson", completed: false, videoId: "LDV41AlayVw", duration: "5:53" },
              { id: 6, title: "BÀI 5: ĐẦU TƯ TỪ ĐÂU?", type: "lesson", completed: false, videoId: "ULEMECVelP0", duration: "6:28" },
              { id: 7, title: "BÀI 6: PHÂN BIỆT CỔ PHIẾU VÀ TRÁI PHIẾU", type: "lesson", completed: false, videoId: "EVPC25qboNA", duration: "5:53" },
              { id: 8, title: "BÀI 7: NÊN VỮNG LÝ THUYẾT RỒI MỚI ĐẦU TƯ HAY VỪA HỌC LÝ THUYẾT VỪA ĐẦU TƯ", type: "lesson", completed: false, videoId: "KiL4T9kYZDQ", duration: "5:14" }
            ]
          },
          {
            title: "Phần 3: Quản lý và phát triển tài chính",
            lessons: [
              { id: 9, title: "BÀI 8: THẾ NÀO LÀ TIÊU TIỀN ĐÚNG ĐẮN?", type: "lesson", completed: false, videoId: "dEXI-gGyAmI", duration: "6:05" },
              { id: 10, title: "BÀI 9: PHÁT TRIỂN CÁC CẤP ĐỘ TÀI CHÍNH ĐỂ TRỞ THÀNH NHÀ ĐẦU TƯ CHUYÊN NGHIỆP", type: "lesson", completed: false, videoId: "11erHIGnSPo", duration: "5:03" },
              { id: 11, title: "BÀI 10: 5 BÍ KÍP QUẢN LÝ TÀI CHÍNH SẼ THAY ĐỔI CUỘC SỐNG CỦA BẠN", type: "lesson", completed: false, videoId: "06yoYByxnrs", duration: "N/A" },
              { id: 12, title: "BÀI 11: 5 KÊNH ĐẦU TƯ TÀI CHÍNH BẠN NÊN THỬ MỘT LẦN TRONG ĐỜI", type: "lesson", completed: false, videoId: "FF8V1azhbaw", duration: "7:53" },
              { id: 13, title: "BÀI 12: CÁCH LẬP KẾ HOẠCH TÀI CHÍNH CÁ NHÂN TỪ CON SỐ 0 ĐẾN TỰ DO TÀI CHÍNH", type: "lesson", completed: false, videoId: "M_maFKUUYbE", duration: "8:46" }
            ]
          }
        ]
      },
      'investment': {
        title: "Đầu tư chứng khoán từ A-Z",
        sections: [
          {
            title: "Phần 1: Kiến thức cơ bản",
            lessons: [
              { id: 1, title: "BÀI 1: GIỚI THIỆU VỀ THỊ TRƯỜNG CHỨNG KHOÁN", type: "lesson", completed: true, videoId: "TaiZS8-i6L0", duration: "N/A" },
              { id: 2, title: "BÀI 2: CÁC LOẠI CHỨNG KHOÁN", type: "lesson", completed: false, videoId: "UB3RZ7RzJc8", duration: "N/A" },
              { id: 3, title: "BÀI 3: CÁCH THỨC GIAO DỊCH CHỨNG KHOÁN", type: "lesson", completed: false, videoId: "B40G4nUjPv4", duration: "N/A" },
              { id: 4, title: "BÀI 4: PHÂN TÍCH CƠ BẢN", type: "lesson", completed: false, videoId: "TTJUpK28t1Q", duration: "N/A" },
              { id: 5, title: "BÀI 5: PHÂN TÍCH KỸ THUẬT", type: "lesson", completed: false, videoId: "qyLOuaCveK0", duration: "N/A" }
            ]
          },
          {
            title: "Phần 2: Chiến lược đầu tư",
            lessons: [
              { id: 6, title: "BÀI 6: XÂY DỰNG DANH MỤC ĐẦU TƯ", type: "lesson", completed: false, videoId: "gD0r43wbjnE", duration: "N/A" },
              { id: 7, title: "BÀI 7: QUẢN LÝ RỦI RO", type: "lesson", completed: false, videoId: "qiRNtNvWPY4", duration: "N/A" },
              { id: 8, title: "BÀI 8: TÂM LÝ HỌC TRONG ĐẦU TƯ", type: "lesson", completed: false, videoId: "nFD3tXtRpVA", duration: "N/A" },
              { id: 9, title: "BÀI 9: CHIẾN LƯỢC ĐẦU TƯ DÀI HẠN", type: "lesson", completed: false, videoId: "NKm6UtxWWUc", duration: "N/A" },
              { id: 10, title: "BÀI 10: CHIẾN LƯỢC ĐẦU TƯ NGẮN HẠN", type: "lesson", completed: false, videoId: "IVhlYPO0ae4", duration: "N/A" }
            ]
          },
          {
            title: "Phần 3: Nâng cao",
            lessons: [
              { id: 11, title: "BÀI 11: PHÁI SINH VÀ HỢP ĐỒNG TƯƠNG LAI", type: "lesson", completed: false, videoId: "Julqxj_n42w", duration: "N/A" },
              { id: 12, title: "BÀI 12: ĐẦU TƯ QUỐC TẾ", type: "lesson", completed: false, videoId: "F9jnuEGA7V4", duration: "N/A" },
              { id: 13, title: "BÀI 13: TỐI ƯU HÓA THUẾ", type: "lesson", completed: false, videoId: "EfMfrBahukA", duration: "N/A" },
              { id: 14, title: "BÀI 14: XÂY DỰNG CHIẾN LƯỢC ĐẦU TƯ CÁ NHÂN", type: "lesson", completed: false, videoId: "qlraY5eO3-o", duration: "N/A" },
              { id: 15, title: "BÀI 15: TỔNG KẾT VÀ HƯỚNG DẪN TIẾP THEO", type: "lesson", completed: false, videoId: "sNh8NWP0uCk", duration: "N/A" }
            ]
          }
        ]
      },
      'banking': {
        title: "Nghiệp vụ ngân hàng hiện đại",
        sections: [
          {
            title: "Phần 1: Cơ sở lý thuyết Nghiệp vụ Ngân hàng",
            lessons: [
              { id: 1, title: "Bài 1: Tổng quát nghiệp vụ ngân hàng", type: "lesson", completed: true, videoId: "txh5aG0eh0Q", duration: "1:20:57" },
              { id: 2, title: "Bài 2: Huy động vốn", type: "lesson", completed: false, videoId: "A1HkkLZdVh0", duration: "1:12:08" },
              { id: 3, title: "Bài 3: Nghiệp vụ thanh toán", type: "lesson", completed: false, videoId: "2V_wGy7a62o", duration: "1:16:02" }
            ]
          },
          {
            title: "Phần 2: Nghiệp vụ Tín dụng Ngân hàng",
            lessons: [
              { id: 4, title: "Bài 4: Phân tích tín dụng", type: "lesson", completed: false, videoId: "fk2OCqzWdTI", duration: "1:16:57" },
              { id: 5, title: "Bài 5: Hợp đồng tín dụng và Cho vay ngắn hạn", type: "lesson", completed: false, videoId: "gOi65xm_YGA", duration: "2:12:50" },
              { id: 6, title: "Bài 6: Cho vay trung hạn và dài hạn", type: "lesson", completed: false, videoId: "8GPhxPEC1y8", duration: "32:52" }
            ]
          }
        ]
      },
      'personal-finance': {
        title: "Quản lý tài chính cá nhân thông minh",
        sections: [
          {
            title: "Phần 1: Hành trình Tự do Tài chính - Nền tảng",
            lessons: [
              { id: 1, title: "Phần 1: Giới thiệu về Tự do Tài chính", type: "lesson", completed: true, videoId: "HOPMqOCZ0jI", duration: "24:00" },
              { id: 2, title: "Phần 2: 12 Bước đạt Tự do Tài chính - Tổng quan", type: "lesson", completed: false, videoId: "GlUvl-MWn6E", duration: "19:00" },
              { id: 3, title: "Phần 3: Giai đoạn Căng thẳng và Bất an", type: "lesson", completed: false, videoId: "rqtDSOCUEj0", duration: "19:00" },
              { id: 4, title: "Phần 4: Xây dựng Nền móng Tài chính", type: "lesson", completed: false, videoId: "lKhIompb0M0", duration: "35:00" },
              { id: 5, title: "Phần 5: Giai đoạn Đầu tư và Phát triển", type: "lesson", completed: false, videoId: "JgTij31JCqM", duration: "29:00" },
              { id: 6, title: "Phần 6: Xây dựng Thu nhập Thụ động", type: "lesson", completed: false, videoId: "a-gk85cFt4w", duration: "21:00" }
            ]
          },
          {
            title: "Phần 2: Kiến thức và Kỹ năng Tài chính",
            lessons: [
              { id: 7, title: "Nhận diện góc nhìn sai lệch về Tài chính", type: "lesson", completed: false, videoId: "012JjvAAE9s", duration: "19:00" },
              { id: 8, title: "Xây dựng nền tảng Đầu tư vững chắc", type: "lesson", completed: false, videoId: "26o_z2gcpyU", duration: "17:00" },
              { id: 9, title: "4 Mức độ Tiết kiệm hiệu quả", type: "lesson", completed: false, videoId: "DJr2hclTuLM", duration: "15:00" }
            ]
          },
          {
            title: "Phần 3: Ứng dụng và Thực hành",
            lessons: [
              { id: 10, title: "Những sự thật quan trọng về Tiền bạc", type: "lesson", completed: false, videoId: "6Snew5np1tE", duration: "17:00" },
              { id: 11, title: "2 Loại Tài sản nên Tích lũy", type: "lesson", completed: false, videoId: "Ea8qJsQXHlI", duration: "20:00" },
              { id: 12, title: "4 Cách Đầu tư để đạt Tự do Tài chính", type: "lesson", completed: false, videoId: "J2-no9gQhzg", duration: "21:00" },
              { id: 13, title: "3 Điều vô giá Tự do Tài chính mang lại", type: "lesson", completed: false, videoId: "HBkZgvMe2EE", duration: "17:00" }
            ]
          }
        ]
      },
      'forex': {
        title: "Trading Forex cho người mới",
        sections: [
          {
            title: "Phần 1: Kiến thức nền tảng Forex",
            lessons: [
              { id: 1, title: "Chiến lược Trading duy nhất bạn cần để sinh lời | Swing Trading", type: "lesson", completed: true, videoId: "HYCdwPCLc8U", duration: "17:47" },
              { id: 2, title: "Cách Trade Forex cho người mới bắt đầu 2025 | Hướng dẫn đầy đủ", type: "lesson", completed: false, videoId: "Y6xyQRDbJvU", duration: "27:27" },
              { id: 3, title: "6 Mô hình Nến Đảo chiều cần biết trước khi bắt đầu Trading", type: "lesson", completed: false, videoId: "ibgnOrk9MLo", duration: "8:56" },
              { id: 4, title: "Bắt đầu Trading rất khó, cho đến khi bạn xem Video này", type: "lesson", completed: false, videoId: "iKKyxN9IIKg", duration: "9:42" },
              { id: 5, title: "Cách sử dụng Tin tức để kiếm tiền Trading Forex | Phân tích Cơ bản", type: "lesson", completed: false, videoId: "x7Ki7QV7USU", duration: "7:44" },
              { id: 6, title: "Cách bắt đầu Forex Trading từng bước cho người mới 2025 | Hướng dẫn đầy đủ", type: "lesson", completed: false, videoId: "4NBUlfnETBY", duration: "46:05" }
            ]
          },
          {
            title: "Phần 2: Kỹ năng Trading nâng cao",
            lessons: [
              { id: 7, title: "Cách trở thành Trader có lãi trong vòng chưa đầy 30 ngày", type: "lesson", completed: false, videoId: "WjsSd5Owf9A", duration: "18:10" },
              { id: 8, title: "Cách bắt đầu Day Trading cho người mới 2025 | Khóa học miễn phí", type: "lesson", completed: false, videoId: "NFb0rX2LOp0", duration: "55:26" },
              { id: 9, title: "Cách kiếm $250 mỗi ngày với Day Trading khi còn là NGƯỜI MỚI", type: "lesson", completed: false, videoId: "Vjda5pI5vKQ", duration: "21:42" },
              { id: 10, title: "Chiến lược Support & Resistance rất khó, cho đến khi tôi hiểu điều này", type: "lesson", completed: false, videoId: "7KedELXv68I", duration: "21:31" },
              { id: 11, title: "Những SAI LẦM Trading tồi tệ nhất và Cách sửa chúng", type: "lesson", completed: false, videoId: "vjlttwZOBMo", duration: "11:06" },
              { id: 12, title: "Chiến lược Quản lý Rủi ro tốt nhất để kiếm hàng triệu từ Trading", type: "lesson", completed: false, videoId: "VzMlFZbWA0Y", duration: "12:38" }
            ]
          },
          {
            title: "Phần 3: Chiến lược Trading chuyên nghiệp",
            lessons: [
              { id: 13, title: "Chiến lược Forex dễ nhất để có lãi 2025 | Shift of Structure", type: "lesson", completed: false, videoId: "X0Ua4XeA2Xo", duration: "19:45" },
              { id: 14, title: "Chiến lược Trading này đã giúp tôi kiếm $70,000 trong 1 ngày | Mô hình Head And Shoulders", type: "lesson", completed: false, videoId: "JA4N8nlycXY", duration: "12:59" },
              { id: 15, title: "Tôi đã chuyển $1,100 thành $17,000 trong 1 tháng Trading Forex", type: "lesson", completed: false, videoId: "7otxB9VIiDs", duration: "11:12" },
              { id: 16, title: "Hướng dẫn tối thượng về Chiến lược Price Action Trading cho người mới", type: "lesson", completed: false, videoId: "SvJ1ZmZKfc0", duration: "14:28" },
              { id: 17, title: "Hướng dẫn Forex Trading cho người mới 2025 (3+ giờ)", type: "lesson", completed: false, videoId: "MFqvLMctU_U", duration: "3:41:12" },
              { id: 18, title: "Tôi đã kiếm $346,000 trong 1 giao dịch để chứng minh không phải may mắn (phân tích đầy đủ)", type: "lesson", completed: false, videoId: "phphBbRex1M", duration: "24:52" }
            ]
          },
          {
            title: "Phần 4: Chiến thuật nâng cao và Tăng trưởng tài khoản",
            lessons: [
              { id: 19, title: "Cách bắt đầu SWING TRADING cho người mới 2025 | Hướng dẫn đầy đủ từng bước", type: "lesson", completed: false, videoId: "bYROdw0xJdc", duration: "28:26" },
              { id: 20, title: "Cách tăng trưởng tài khoản Forex nhỏ nhanh đến mức cảm giác bất hợp pháp", type: "lesson", completed: false, videoId: "McRKOYBcAiI", duration: "19:41" },
              { id: 21, title: "Bản thiết kế để trở thành Trader có lãi năm 2025", type: "lesson", completed: false, videoId: "2pEtH0g0z1o", duration: "32:27" },
              { id: 22, title: "Khóa học Trading Forex toàn diện 2025", type: "lesson", completed: false, videoId: "8rqdN1FnY4s", duration: "1:16:38" }
            ]
          }
        ]
      },
      'financial-analysis': {
        title: "Phân tích báo cáo tài chính doanh nghiệp",
        sections: [
          {
            title: "Phần 1: Tổng quan và Cơ sở",
            lessons: [
              { id: 1, title: "Bài 1: Phân tích báo cáo tài chính - Cách đọc báo cáo tài chính", type: "lesson", videoId: "Bwzm0v53edk", duration: "1:56:00" },
              { id: 2, title: "Bài 2: Phân tích bảng cân đối kế toán và báo cáo thu nhập", type: "lesson", videoId: "2ENJjbxm7FI", duration: "1:15:38" },
              { id: 3, title: "Bài 3: Báo cáo lưu chuyển tiền tệ", type: "lesson", completed: false, videoId: "CGa9BoLlO3o", duration: "40:44" }
            ]
          },
          {
            title: "Phần 2: Phân tích chuyên sâu",
            lessons: [
              { id: 4, title: "Bài 4: Phân tích khả năng thanh toán và hoạt động", type: "lesson", videoId: "ia-zwIHhemg", duration: "1:04:37" },
              { id: 5, title: "Bài 5: Phân tích tỷ số đòn bẩy tài chính", type: "lesson", videoId: "9BZvmdLUv74", duration: "31:09" },
              { id: 6, title: "Bài tập thực hành - Phân tích tổng hợp", type: "lesson", videoId: "-Pyx4BG9CHk", duration: "12:24" }
            ]
          },
          {
            title: "Phần 3: Ứng dụng thực tế",
            lessons: [
              { id: 7, title: "Case study: Phân tích báo cáo tài chính doanh nghiệp thực tế", type: "lesson", videoId: "4QFb-a2vO3s", duration: "57:47" }
            ]
          }
        ]
      }
    };
    
    // Get course data based on currentCourseId, fallback to finance-basic
    const courseData = coursesData[currentCourseId] || coursesData['finance-basic'];
    
    let currentLesson = courseData.sections[0].lessons[0];

    // Toggle sidebar
    const toggleBtn = document.getElementById('toggleSidebar');
    const sidebar = document.getElementById('learningSidebar');
    toggleBtn.addEventListener('click', function() {
      sidebar.classList.toggle('collapsed');
    });

    // Render lessons
    function renderLessons() {
      const lessonsList = document.getElementById('lessonsList');
      let html = '';
      
      // Build flat list of all lessons for proper sequential checking
      let allLessons = [];
      courseData.sections.forEach(function(section) {
        section.lessons.forEach(function(lesson) {
          allLessons.push({lesson: lesson, section: section});
        });
      });
      
      let currentSectionIndex = 0;
      courseData.sections.forEach(function(section) {
        html += '<div class="lesson-section">';
        html += '<div class="section-title">' + section.title + '</div>';
        html += '<div class="section-lessons">';
        
        section.lessons.forEach(function(lesson, indexInSection) {
          const activeClass = lesson.id === currentLesson.id ? 'active' : '';
          const isCompleted = isLessonCompleted(lesson.id);
          const completedClass = isCompleted ? 'completed' : '';
          
          // Check if previous lesson is completed (across all sections)
          const globalIndex = allLessons.findIndex(function(item) { 
            return item.lesson.id === lesson.id; 
          });
          const isPreviousCompleted = globalIndex === 0 || isLessonCompleted(allLessons[globalIndex - 1].lesson.id);
          const isLocked = !isPreviousCompleted;
          const lockedClass = isLocked ? 'locked' : '';
          
          // Icon: checkmark if completed, lock if locked, play button otherwise
          let icon = '▶';
          if (isCompleted) icon = '✓';
          else if (isLocked) icon = '🔒';
          
          const duration = lesson.duration ? ' (' + lesson.duration + ')' : '';
          
          html += '<div class="lesson-item ' + activeClass + ' ' + completedClass + ' ' + lockedClass + '" onclick="selectLesson(' + lesson.id + ', ' + isLocked + ')">';
          html += '<span class="lesson-icon">' + icon + '</span>';
          html += '<span class="lesson-name">' + lesson.title + duration + '</span>';
          html += '</div>';
        });
        
        html += '</div></div>';
        currentSectionIndex++;
      });
      
      lessonsList.innerHTML = html;
      updateProgress();
    }

    // YouTube Player instance
    let player = null;
    let progressInterval = null;
    let watchStartTime = null;
    let totalWatchTime = 0;
    let youtubeAPIReady = false;

    // Load YouTube IFrame API
    function onYouTubeIframeAPIReady() {
      console.log('YouTube IFrame API ready');
      youtubeAPIReady = true;
    }

    // Get lesson completion from localStorage
    function isLessonCompleted(lessonId) {
      const key = 'completed_' + currentCourseId + '_' + lessonId;
      return localStorage.getItem(key) === 'true';
    }

    // Save lesson completion to localStorage
    function saveLessonCompletion(lessonId) {
      const key = 'completed_' + currentCourseId + '_' + lessonId;
      localStorage.setItem(key, 'true');
    }

    // Format time (seconds to mm:ss)
    function formatTime(seconds) {
      const mins = Math.floor(seconds / 60);
      const secs = Math.floor(seconds % 60);
      return mins + ':' + (secs < 10 ? '0' : '') + secs;
    }

    // Update video progress UI
    function updateVideoProgress() {
      if (!player || !player.getCurrentTime) return;
      
      const currentTime = player.getCurrentTime();
      const duration = player.getDuration();
      
      if (duration > 0) {
        const progress = (currentTime / duration) * 100;
        document.getElementById('videoProgressBar').style.width = progress + '%';
        document.getElementById('currentTime').textContent = formatTime(currentTime);
        document.getElementById('totalTime').textContent = formatTime(duration);
      }
    }

    // Select lesson
    function selectLesson(lessonId, isLocked) {
      // Check if lesson is locked
      if (isLocked) {
        showNotification('🔒 Bài học này bị khóa! Vui lòng hoàn thành bài học trước đó trước.', 'error');
        return;
      }
      
      // Find lesson
      let foundLesson = null;
      courseData.sections.forEach(function(section) {
        const lesson = section.lessons.find(function(l) { return l.id === lessonId; });
        if (lesson) foundLesson = lesson;
      });
      
      if (!foundLesson) return;
      
      currentLesson = foundLesson;
      
      // Update UI
      document.getElementById('lessonTitle').textContent = currentLesson.title;
      renderLessons();
      
      // Load video with YouTube IFrame API
      if (currentLesson.type === 'lesson' && currentLesson.videoId) {
        loadVideo(currentLesson.videoId, currentLesson.id);
      }
    }

    // Load video with YouTube IFrame API
    function loadVideo(videoId, lessonId) {
      // Wait for YouTube API to be ready
      if (!youtubeAPIReady) {
        console.log('Waiting for YouTube API...');
        setTimeout(function() {
          loadVideo(videoId, lessonId);
        }, 500);
        return;
      }
      
      // Clear existing progress interval
      if (progressInterval) {
        clearInterval(progressInterval);
      }
      
      // Reset watch time tracking
      watchStartTime = null;
      totalWatchTime = 0;
      
      // Destroy existing player
      if (player) {
        player.destroy();
      }
      
      // Create new player
      player = new YT.Player('videoPlayer', {
        height: '100%',
        width: '100%',
        videoId: videoId,
        playerVars: {
          'autoplay': 1,
          'rel': 0,
          'modestbranding': 1,
          'vq': 'hd1080'  // Force HD quality: hd1080, hd720, large (480p), medium (360p), small (240p)
        },
        events: {
          'onReady': function(event) {
            // Set quality to highest available
            var availableQualityLevels = player.getAvailableQualityLevels();
            if (availableQualityLevels && availableQualityLevels.length > 0) {
              player.setPlaybackQuality(availableQualityLevels[0]); // Set to highest quality
            }
            
            // Start progress tracking UI
            progressInterval = setInterval(updateVideoProgress, 1000);
          },
          'onStateChange': function(event) {
            // When video starts playing
            if (event.data === YT.PlayerState.PLAYING) {
              if (!watchStartTime) {
                watchStartTime = Date.now();
              }
            }
            
            // When video is paused
            if (event.data === YT.PlayerState.PAUSED) {
              if (watchStartTime) {
                totalWatchTime += (Date.now() - watchStartTime) / 1000;
                watchStartTime = null;
              }
            }
            
            // Video ended - only save completion if watched till end
            if (event.data === YT.PlayerState.ENDED) {
              if (watchStartTime) {
                totalWatchTime += (Date.now() - watchStartTime) / 1000;
              }
              
              const duration = player.getDuration();
              const watchedPercentage = (totalWatchTime / duration) * 100;
              
              // Must watch at least 95% to count as completed
              if (watchedPercentage >= 95) {
                saveLessonCompletion(lessonId);
                currentLesson.completed = true;
                renderLessons();
                showNotification('✅ Đã hoàn thành bài học! Thời gian xem: ' + formatTime(totalWatchTime), 'success');
              } else {
                showNotification('⚠️ Vui lòng xem hết video để hoàn thành bài học', 'info');
              }
            }
          }
        }
      });
    }

    // Show notification
    function showNotification(message, type) {
      const notification = document.createElement('div');
      notification.className = 'notification notification-' + type;
      notification.textContent = message;
      
      let bgColor = '#2196F3';
      if (type === 'success') bgColor = '#4CAF50';
      else if (type === 'error') bgColor = '#f44336';
      else if (type === 'info') bgColor = '#FF9800';
      
      notification.style.cssText = 
        'position: fixed;' +
        'top: 100px;' +
        'right: 20px;' +
        'padding: 16px 24px;' +
        'background: ' + bgColor + ';' +
        'color: white;' +
        'border-radius: 8px;' +
        'box-shadow: 0 4px 12px rgba(0,0,0,0.15);' +
        'font-weight: 600;' +
        'z-index: 10000;' +
        'animation: slideIn 0.3s ease;';
      
      document.body.appendChild(notification);
      
      setTimeout(function() {
        notification.style.animation = 'slideOut 0.3s ease';
        setTimeout(function() { notification.remove(); }, 300);
      }, 3000);
    }

    // Update progress
    function updateProgress() {
      let totalLessons = 0;
      let completedLessons = 0;
      
      courseData.sections.forEach(function(section) {
        section.lessons.forEach(function(lesson) {
          totalLessons++;
          if (isLessonCompleted(lesson.id)) completedLessons++;
        });
      });
      
      const percent = Math.round((completedLessons / totalLessons) * 100);
      document.getElementById('progressPercent').textContent = percent + '%';
      document.getElementById('progressFill').style.width = percent + '%';
    }

    // Tab switching
    const tabBtns = document.querySelectorAll('.tab-btn');
    const tabContents = document.querySelectorAll('.tab-content');
    
    tabBtns.forEach(function(btn) {
      btn.addEventListener('click', function() {
        const tabName = this.getAttribute('data-tab');
        
        tabBtns.forEach(function(b) { b.classList.remove('active'); });
        tabContents.forEach(function(c) { c.classList.remove('active'); });
        
        this.classList.add('active');
        document.getElementById(tabName).classList.add('active');
      });
    });

    // Copy link
    function copyLink() {
      navigator.clipboard.writeText(window.location.href);
      alert('✓ Đã sao chép đường dẫn!');
    }

    // Save notes
    function saveNotes() {
      const notes = document.querySelector('.notes-textarea').value;
      localStorage.setItem('lesson_notes_' + currentLesson.id, notes);
      alert('✓ Đã lưu ghi chú!');
    }

    // Ask question
    function askQuestion() {
      const question = document.querySelector('.qa-textarea').value.trim();
      if (!question) {
        alert('❌ Vui lòng nhập câu hỏi!');
        return;
      }
      alert('✓ Câu hỏi của bạn đã được gửi!');
      document.querySelector('.qa-textarea').value = '';
    }

    // Hamburger menu
    const hamburgerBtn = document.getElementById('hamburger');
    const mainMenu = document.querySelector('.menu');
    if(hamburgerBtn && mainMenu){
      hamburgerBtn.addEventListener('click', function() {
        const open = hamburgerBtn.getAttribute('aria-expanded') === 'true';
        hamburgerBtn.setAttribute('aria-expanded', String(!open));
        mainMenu.classList.toggle('open');
      });
    }

    // Dropdown menu toggle
    const ddTrigger = document.querySelector('.menu .has-dd');
    const ddParent = ddTrigger ? ddTrigger.closest('.dropdown') : null;
    if(ddTrigger && ddParent){
      ddTrigger.addEventListener('click', function(e) {
        e.preventDefault();
        const wasOpen = ddParent.classList.contains('open');
        document.querySelectorAll('.dropdown.open').forEach(function(d) {
          d.classList.remove('open');
          const trigger = d.querySelector('.has-dd');
          if(trigger) trigger.setAttribute('aria-expanded','false');
        });
        if(!wasOpen) {
          ddParent.classList.add('open');
          ddTrigger.setAttribute('aria-expanded','true');
        } else {
          ddTrigger.setAttribute('aria-expanded','false');
        }
      });
      
      document.addEventListener('click', function(e) {
        if(!ddParent.contains(e.target)){
          ddParent.classList.remove('open');
          ddTrigger.setAttribute('aria-expanded','false');
        }
      });
    }

    // Initialize
    document.addEventListener('DOMContentLoaded', function() {
      renderLessons();
      document.getElementById('courseTitle').textContent = courseData.title;
      // Load first lesson by default
      if (courseData.sections.length > 0 && courseData.sections[0].lessons.length > 0) {
        selectLesson(courseData.sections[0].lessons[0].id);
      }
    });
    
    // Add reset progress button (for debugging - remove in production)
    if (window.location.search.includes('reset=1')) {
      // Clear all completion data for current course
      Object.keys(localStorage).forEach(key => {
        if (key.startsWith('completed_' + currentCourseId)) {
          localStorage.removeItem(key);
        }
      });
      window.location.href = window.location.pathname + '?course=' + currentCourseId;
    }
  </script>

  <!-- YouTube IFrame API -->
  <script src="https://www.youtube.com/iframe_api"></script>
  <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
</body>
</html>
