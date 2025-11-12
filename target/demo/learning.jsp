<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
    String userEmail = (String) session.getAttribute("userEmail");
    String userPhone = (String) session.getAttribute("userPhone");
    String userFullname = (String) session.getAttribute("userFullname");
    
    // Kiểm tra đăng nhập - redirect nếu chưa đăng nhập
    if (loggedIn == null || !loggedIn) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=learning");
        return;
    }
    
    String displayInfo = "";
    if (userPhone != null && userPhone.length() >= 3) {
        displayInfo = "***" + userPhone.substring(userPhone.length() - 3);
    } else if (userEmail != null) {
        displayInfo = userEmail;
    }
    
    // Get course info from URL parameter
    String courseId = request.getParameter("course");
    if (courseId == null) {
        courseId = "history-vietnam";
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
        <a href="${pageContext.request.contextPath}/cart">Giỏ hàng</a>
        <% if (loggedIn != null && loggedIn) { %>
          <a href="${pageContext.request.contextPath}/account" class="user-info"><%= displayInfo %></a>
        <% } else { %>
          <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-sm">Đăng nhập</a>
        <% } %>
      </nav>
      <div class="learning-nav-right">
        <button class="btn-share" title="Chia sẻ">
          <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M13.5 1a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3zM11 2.5a2.5 2.5 0 1 1 .603 1.628l-6.718 3.12a2.499 2.499 0 0 1 0 1.504l6.718 3.12a2.5 2.5 0 1 1-.488.876l-6.718-3.12a2.5 2.5 0 1 1 0-3.256l6.718-3.12A2.5 2.5 0 0 1 11 2.5zm-8.5 4a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3zm11 5.5a1.5 1.5 0 1 0 0 3 1.5 1.5 0 0 0 0-3z"/></svg>
          Chia sẻ
        </button>
        <a href="${pageContext.request.contextPath}/account" class="btn-back">
          <svg width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L2 8.207V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V8.207l.646.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.707 1.5ZM13 7.207V13.5a.5.5 0 0 1-.5.5h-9a.5.5 0 0 1-.5-.5V7.207l5-5 5 5Z"/></svg>
          Khóa học của tôi
        </a>
      </div>
      <button class="hamburger" id="hamburger" aria-label="Mở menu" aria-expanded="false">
        <span></span><span></span><span></span>
      </button>
    </div>
  </header>

  <div class="learning-layout">
    <!-- Sidebar -->
    <aside class="learning-sidebar" id="learningSidebar">
      <div class="sidebar-header">
        <h2 class="course-title" id="courseTitle">Lịch sử Đảng Cộng sản Việt Nam</h2>
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
          <iframe 
            id="videoPlayer"
            width="100%" 
            height="100%" 
            src="https://www.youtube.com/embed/dQw4w9WgXcQ" 
            title="Video bài học"
            frameborder="0" 
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
            allowfullscreen>
          </iframe>
        </div>
      </div>

      <!-- Lesson Info -->
      <div class="lesson-info">
        <div class="lesson-header">
          <div class="lesson-badge" id="lessonBadge">E</div>
          <div class="lesson-details">
            <h1 class="lesson-title" id="lessonTitle">[Lịch sử Đảng] 1.1</h1>
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
            <p>Trong bài học này, bạn sẽ tìm hiểu về lịch sử hình thành và phát triển của Đảng Cộng sản Việt Nam, 
            từ những ngày đầu thành lập cho đến vai trò lãnh đạo cách mạng Việt Nam giành độc lập dân tộc.</p>
            <ul>
              <li>Bối cảnh lịch sử thế giới và Việt Nam đầu thế kỷ XX</li>
              <li>Quá trình hình thành phong trào công nhân Việt Nam</li>
              <li>Sự ra đời của Đảng Cộng sản Việt Nam</li>
              <li>Vai trò lãnh đạo của Đảng trong các giai đoạn lịch sử</li>
            </ul>
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
    // Sample course data
    const courseData = {
      title: "Lịch sử Đảng Cộng sản Việt Nam",
      sections: [
        {
          title: "[Lịch sử Đảng] 1.1",
          lessons: [
            { id: 1, title: "[Lịch sử Đảng] 1.1", type: "lesson", completed: true, videoId: "dQw4w9WgXcQ" },
            { id: 2, title: "Câu hỏi video 1", type: "quiz", completed: false },
            { id: 3, title: "[Lịch sử Đảng] 1.2", type: "lesson", completed: false, videoId: "dQw4w9WgXcQ" },
            { id: 4, title: "Câu hỏi video 2", type: "quiz", completed: false },
            { id: 5, title: "[Lịch sử Đảng] 1.3", type: "lesson", completed: false, videoId: "dQw4w9WgXcQ" },
            { id: 6, title: "Câu hỏi video 3", type: "quiz", completed: false },
            { id: 7, title: "[Lịch sử Đảng] 1.4", type: "lesson", completed: false, videoId: "dQw4w9WgXcQ" },
            { id: 8, title: "Câu hỏi video 4", type: "quiz", completed: false }
          ]
        },
        {
          title: "[Lịch sử Đảng] 2.1",
          lessons: [
            { id: 9, title: "[Lịch sử Đảng] 2.1", type: "lesson", completed: false, videoId: "dQw4w9WgXcQ" },
            { id: 10, title: "Câu hỏi video 5", type: "quiz", completed: false },
            { id: 11, title: "[Lịch sử Đảng] 2.2", type: "lesson", completed: false, videoId: "dQw4w9WgXcQ" },
            { id: 12, title: "Câu hỏi video 6", type: "quiz", completed: false },
            { id: 13, title: "[Lịch sử Đảng] 2.3", type: "lesson", completed: false, videoId: "dQw4w9WgXcQ" },
            { id: 14, title: "Câu hỏi video 7", type: "quiz", completed: false }
          ]
        },
        {
          title: "[Lịch sử Đảng] 3.1",
          lessons: [
            { id: 15, title: "[Lịch sử Đảng] 3.1", type: "lesson", completed: false, videoId: "dQw4w9WgXcQ" }
          ]
        }
      ]
    };

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
          const completedClass = lesson.completed ? 'completed' : '';
          const icon = lesson.completed ? '✓' : (lesson.type === 'quiz' ? '❓' : '▶');
          
          html += '<div class="lesson-item ' + activeClass + ' ' + completedClass + '" onclick="selectLesson(' + lesson.id + ')">';
          html += '<span class="lesson-icon">' + icon + '</span>';
          html += '<span class="lesson-name">' + lesson.title + '</span>';
          html += '</div>';
        });
        
        html += '</div></div>';
      });
      
      lessonsList.innerHTML = html;
      updateProgress();
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
      
      // Update video
      if (currentLesson.type === 'lesson' && currentLesson.videoId) {
        document.getElementById('videoPlayer').src = 
          'https://www.youtube.com/embed/' + currentLesson.videoId + '?autoplay=1';
      }
      
      // Update UI
      document.getElementById('lessonTitle').textContent = currentLesson.title;
      renderLessons();
    }

    // Update progress
    function updateProgress() {
      let totalLessons = 0;
      let completedLessons = 0;
      
      courseData.sections.forEach(function(section) {
        section.lessons.forEach(function(lesson) {
          totalLessons++;
          if (lesson.completed) completedLessons++;
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
    });
  </script>

  <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
</body>
</html>
