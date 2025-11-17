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
              { id: 1, title: "LỘ TRÌNH XÂY DỰNG KIẾN THỨC TÀI CHÍNH", type: "lesson", completed: true, videoId: "madrRu_iU6U", duration: "3:11" },
              { id: 2, title: "BÀI 1: CÁC THUẬT NGỮ TÀI CHÍNH CƠ BẢN CẦN BIẾT", type: "lesson", completed: false, videoId: "wqcLaQo0m5s", duration: "4:15" },
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
            title: "Phần 1: Tổng quan ngân hàng",
            lessons: [
              { id: 1, title: "Vai trò của ngân hàng trong nền kinh tế", type: "lesson", completed: true, videoId: "TEMP_BANK_1", duration: "12:00" },
              { id: 2, title: "Các loại hình dịch vụ ngân hàng", type: "lesson", completed: false, videoId: "TEMP_BANK_2", duration: "15:00" },
              { id: 3, title: "Nghiệp vụ cho vay và huy động vốn", type: "lesson", completed: false, videoId: "TEMP_BANK_3", duration: "18:00" }
            ]
          },
          {
            title: "Phần 2: Nghiệp vụ chuyên sâu",
            lessons: [
              { id: 4, title: "Quản lý rủi ro tín dụng", type: "lesson", completed: false, videoId: "TEMP_BANK_4", duration: "20:00" },
              { id: 5, title: "Dịch vụ ngân hàng điện tử", type: "lesson", completed: false, videoId: "TEMP_BANK_5", duration: "16:00" }
            ]
          }
        ]
      },
      'personal-finance': {
        title: "Tài chính cá nhân thông minh",
        sections: [
          {
            title: "Phần 1: Quản lý tiền bạc cơ bản",
            lessons: [
              { id: 1, title: "Lập ngân sách cá nhân hiệu quả", type: "lesson", completed: true, videoId: "TEMP_PF_1", duration: "10:00" },
              { id: 2, title: "Cách tiết kiệm và tích lũy", type: "lesson", completed: false, videoId: "TEMP_PF_2", duration: "12:00" },
              { id: 3, title: "Quản lý nợ và thẻ tín dụng", type: "lesson", completed: false, videoId: "TEMP_PF_3", duration: "14:00" }
            ]
          },
          {
            title: "Phần 2: Đầu tư và quy hoạch tài chính",
            lessons: [
              { id: 4, title: "Xây dựng quỹ khẩn cấp", type: "lesson", completed: false, videoId: "TEMP_PF_4", duration: "11:00" },
              { id: 5, title: "Bảo hiểm và bảo vệ tài sản", type: "lesson", completed: false, videoId: "TEMP_PF_5", duration: "13:00" },
              { id: 6, title: "Lập kế hoạch hưu trí sớm", type: "lesson", completed: false, videoId: "TEMP_PF_6", duration: "15:00" }
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
      
      courseData.sections.forEach(function(section) {
        html += '<div class="lesson-section">';
        html += '<div class="section-title">' + section.title + '</div>';
        html += '<div class="section-lessons">';
        
        section.lessons.forEach(function(lesson) {
          const activeClass = lesson.id === currentLesson.id ? 'active' : '';
          const isCompleted = isLessonCompleted(lesson.id);
          const completedClass = isCompleted ? 'completed' : '';
          const icon = isCompleted ? '✓' : '▶';
          const duration = lesson.duration ? ' (' + lesson.duration + ')' : '';
          
          html += '<div class="lesson-item ' + activeClass + ' ' + completedClass + '" onclick="selectLesson(' + lesson.id + ')">';
          html += '<span class="lesson-icon">' + icon + '</span>';
          html += '<span class="lesson-name">' + lesson.title + duration + '</span>';
          html += '</div>';
        });
        
        html += '</div></div>';
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
    function selectLesson(lessonId) {
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
          'modestbranding': 1
        },
        events: {
          'onReady': function(event) {
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
  </script>

  <!-- YouTube IFrame API -->
  <script src="https://www.youtube.com/iframe_api"></script>
  <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
</body>
</html>
