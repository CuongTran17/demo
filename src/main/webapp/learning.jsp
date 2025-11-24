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
  <style>
    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
    @keyframes slideIn {
      from { transform: translateX(100%); opacity: 0; }
      to { transform: translateX(0); opacity: 1; }
    }
    @keyframes slideOut {
      from { transform: translateX(0); opacity: 1; }
      to { transform: translateX(100%); opacity: 0; }
    }
  </style>
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
                <a href="${pageContext.request.contextPath}/learning?course=python-basics">Lập trình - CNTT</a>
                <a href="${pageContext.request.contextPath}/learning?course=finance-basic">Tài chính</a>
                <a href="${pageContext.request.contextPath}/learning?course=data-basic">Data analyst</a>
                <a href="${pageContext.request.contextPath}/learning?course=blockchain-basic">Blockchain</a>
                <a href="${pageContext.request.contextPath}/learning?course=accounting-basic">Kế toán</a>
                <a href="${pageContext.request.contextPath}/learning?course=content-marketing">Marketing</a>
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
        <div class="sidebar-actions">
          <a href="${pageContext.request.contextPath}/courses" class="btn btn-sm btn-outline">← Quay lại danh sách khóa học</a>
        </div>
      </div>

      <div class="sidebar-content">
        <div class="lessons-list" id="lessonsList">
          <div class="loading-lessons" style="text-align: center; padding: 20px; color: #666;">
            <div class="spinner" style="margin: 0 auto 10px; width: 40px; height: 40px; border: 4px solid #f3f3f3; border-top: 4px solid #2196F3; border-radius: 50%; animation: spin 1s linear infinite;"></div>
            <p>Đang tải danh sách bài học...</p>
          </div>
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
    // ============ DEBUG SESSION INFO ============
    console.log('=== SESSION DEBUG ===');
    console.log('Logged in:', <%= loggedIn != null && loggedIn %>);
    console.log('User ID:', <%= userId != null ? userId : "null" %>);
    console.log('User email:', '<%= userEmail != null ? userEmail : "null" %>');
    console.log('====================');
    // ============================================

    // Load lessons from API instead of hardcoded data
    let courseData = null;
    let currentLesson = null;
    let currentCourseId = '<%= courseId %>';

    async function loadLessons() {
      try {
        console.log('Fetching lessons from:', '<%= request.getContextPath() %>/api/lessons?courseId=' + currentCourseId);
        const response = await fetch('<%= request.getContextPath() %>/api/lessons?courseId=' + currentCourseId);
        console.log('Lessons response status:', response.status);
        
        if (response.ok) {
          const lessons = await response.json();
          console.log('Loaded lessons from server:', lessons);

          // Group lessons by section
          const sectionsMap = new Map();
          lessons.forEach(lesson => {
            if (!sectionsMap.has(lesson.sectionId)) {
              sectionsMap.set(lesson.sectionId, {
                title: `Section ${lesson.sectionId}`,
                lessons: []
              });
            }
            sectionsMap.get(lesson.sectionId).lessons.push({
              id: lesson.lessonId,
              title: lesson.lessonTitle,
              type: "lesson",
              videoId: lesson.videoUrl ? extractVideoId(lesson.videoUrl) : null,
              duration: lesson.duration || "0:00",
              content: lesson.lessonContent
            });
          });

          // Convert to array and sort sections
          courseData = {
            title: getCourseTitle(currentCourseId),
            sections: Array.from(sectionsMap.values()).sort((a, b) => {
              const aNum = parseInt(a.title.replace('Section ', ''));
              const bNum = parseInt(b.title.replace('Section ', ''));
              return aNum - bNum;
            })
          };

          // Set current lesson to first lesson if available
          if (courseData.sections.length > 0 && courseData.sections[0].lessons.length > 0) {
            currentLesson = courseData.sections[0].lessons[0];
          }

          renderLessons();
          updateCourseTitle();
          console.log('✅ Lessons loaded and rendered successfully');
        } else {
          console.error('❌ Failed to load lessons:', response.status);
          // Fallback to basic structure
          courseData = {
            title: getCourseTitle(currentCourseId),
            sections: []
          };
        }
      } catch (error) {
        console.error('❌ Error loading lessons:', error);
        // Fallback to basic structure
        courseData = {
          title: getCourseTitle(currentCourseId),
          sections: []
        };
      }
    }

    function extractVideoId(url) {
      if (!url) return null;
      if (url.includes('youtube.com') || url.includes('youtu.be')) {
        if (url.includes('v=')) {
          return url.split('v=')[1].split('&')[0];
        } else if (url.includes('youtu.be/')) {
          return url.split('youtu.be/')[1].split('?')[0];
        }
      }
      return url; // Return as-is if not YouTube URL
    }

    function getCourseTitle(courseId) {
      const titles = {
        'finance-basic': 'Tài chính cơ bản cho người mới bắt đầu',
        'forex': 'Trading Forex cho người mới',
        'accounting': 'Kế toán cho người mới',
        'blockchain': 'Blockchain và Cryptocurrency',
        'data': 'Khoa học dữ liệu',
        'marketing': 'Marketing số'
      };
      return titles[courseId] || 'Khóa học';
    }

    function updateCourseTitle() {
      if (courseData) {
        document.getElementById('courseTitle').textContent = courseData.title;
      }
    }
    // Load lessons from database - moved to DOMContentLoaded
    // loadLessons();

    // Toggle sidebar
    const toggleBtn = document.getElementById('toggleSidebar');
    const sidebar = document.getElementById('learningSidebar');
    toggleBtn.addEventListener('click', function() {
      sidebar.classList.toggle('collapsed');
    });

    // Render lessons
    function renderLessons() {
      if (!courseData || !courseData.sections) {
        console.log('Course data not loaded yet');
        return;
      }
      
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
          const activeClass = currentLesson && lesson.id === currentLesson.id ? 'active' : '';
          const isCompleted = isLessonCompleted(lesson.id);
          const completedClass = isCompleted ? 'completed' : '';
          
          // LOGIC: Chỉ bài đầu tiên mở khóa, các bài sau phải xem tuần tự
          const globalIndex = allLessons.findIndex(function(item) { 
            return item.lesson.id === lesson.id; 
          });
          
          // Bài đầu tiên luôn mở, các bài sau PHẢI hoàn thành bài trước mới mở
          let isLocked = false;
          if (globalIndex > 0) {
            isLocked = !isLessonCompleted(allLessons[globalIndex - 1].lesson.id);
          }
          
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
    let currentLessonId = null;
    let progressCheckInterval = null;
    let isSavingProgress = false; // Prevent duplicate saves
    let lastKnownTime = 0; // Track last video position to detect seeking
    let watchedSegments = []; // Track which segments have been watched

    // Load YouTube IFrame API
    function onYouTubeIframeAPIReady() {
      console.log('YouTube IFrame API ready');
      youtubeAPIReady = true;
    }

    // Server-side lesson progress tracking
    let completedLessonsCache = new Set();
    
    // Load completed lessons from server
    async function loadCompletedLessons() {
      try {
        const url = '<%= request.getContextPath() %>/api/lesson-progress?courseId=' + currentCourseId;
        console.log('Fetching progress from:', url);
        
        const response = await fetch(url, {
          method: 'GET',
          credentials: 'include'
        });
        console.log('Response status:', response.status);
        
        if (response.ok) {
          const data = await response.json();
          console.log('Server returned:', data);
          console.log('completedLessons field:', data.completedLessons);
          console.log('Type:', typeof data.completedLessons);
          
          // Convert all to strings for consistency
          if (data.completedLessons && Array.isArray(data.completedLessons)) {
            completedLessonsCache = new Set(data.completedLessons.map(String));
            console.log('Loaded completed lessons:', Array.from(completedLessonsCache));
          } else {
            console.error('completedLessons is not an array:', data.completedLessons);
            completedLessonsCache = new Set();
          }
          updateProgress();
        } else {
          const errorText = await response.text();
          console.error('Server error:', response.status, errorText);
        }
      } catch (error) {
        console.error('Failed to load lesson progress:', error);
      }
    }
    
    // Check if lesson is completed
    function isLessonCompleted(lessonId) {
      return completedLessonsCache.has(String(lessonId));
    }

    // Save lesson completion to server
    async function saveLessonCompletion(lessonId) {
      // Prevent duplicate saves
      if (isLessonCompleted(lessonId)) {
        console.log('[SAVE] Lesson', lessonId, 'already completed, skipping');
        return Promise.resolve();
      }
      
      // Prevent concurrent saves
      if (isSavingProgress) {
        console.log('[SAVE] Already saving, skipping duplicate request');
        return Promise.resolve();
      }
      
      isSavingProgress = true;
      
      try {
        const params = new URLSearchParams();
        params.append('courseId', currentCourseId);
        params.append('lessonId', String(lessonId));
        params.append('action', 'complete');
        
        console.log('[SAVE] Saving lesson:', lessonId, 'for course:', currentCourseId);
        console.log('[SAVE] POST data:', params.toString());
        
        const response = await fetch('<%= request.getContextPath() %>/api/lesson-progress', {
          method: 'POST',
          credentials: 'include',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: params.toString()
        });
        
        console.log('[SAVE] Response status:', response.status);
        
        if (response.ok) {
          const result = await response.json();
          console.log('[SAVE] ✅ SUCCESS:', result);
          
          // Update cache immediately
          completedLessonsCache.add(String(lessonId));
          console.log('[SAVE] Cache updated. Completed lessons:', Array.from(completedLessonsCache));
          
          // Update UI immediately
          updateProgress();
          renderLessons();
          
          isSavingProgress = false;
          return Promise.resolve(result);
        } else {
          const errorText = await response.text();
          console.error('[SAVE] ❌ FAILED:', response.status, errorText);
          isSavingProgress = false;
          return Promise.reject(new Error(errorText));
        }
      } catch (error) {
        console.error('[SAVE] ❌ ERROR:', error);
        isSavingProgress = false;
        return Promise.reject(error);
      }
    }

    // Check if current video should be marked as complete
    function checkAndSaveProgress() {
      if (!player) {
        console.log('[CHECK] No player');
        return;
      }
      if (!currentLessonId) {
        console.log('[CHECK] No currentLessonId');
        return;
      }
      
      try {
        const duration = player.getDuration();
        const currentTime = player.getCurrentTime();
        const currentPosPercentage = (currentTime / duration) * 100;
        const actualWatchPercentage = (totalWatchTime / duration) * 100;
        const isCompleted = isLessonCompleted(currentLessonId);
        
        console.log('[CHECK] Lesson:', currentLessonId, '| Position:', currentTime.toFixed(1) + 's /', duration.toFixed(1) + 's (', currentPosPercentage.toFixed(1) + '%)', '| Actual watch time:', totalWatchTime.toFixed(1) + 's (', actualWatchPercentage.toFixed(1) + '%)', '| Completed:', isCompleted);
        
        if (!duration || duration <= 0) {
          console.log('[CHECK] Invalid duration');
          return;
        }
        
        // CRITICAL: Use ACTUAL watch time, not video position
        // Must watch 80% of video duration continuously (not just seek to 80%)
        if (actualWatchPercentage >= 80 && !isCompleted && !isSavingProgress) {
          console.log('[CHECK] ✅ TRIGGERING AUTO-SAVE for lesson', currentLessonId);
          saveLessonCompletion(currentLessonId).then(function(result) {
            console.log('[CHECK] ✅ Save completed successfully');
            if (currentLesson) currentLesson.completed = true;
          }).catch(function(error) {
            console.error('[CHECK] ❌ Save failed:', error);
          });
        }
      } catch (e) {
        console.error('[CHECK] ❌ Error:', e);
      }
    }
    
    // Manual test function - call from console: testSave(1)
    window.testSave = async function(lessonId) {
      console.log('=== MANUAL TEST SAVE ===');
      await saveLessonCompletion(lessonId || 1);
      console.log('Done. Reloading data...');
      await loadCompletedLessons();
    };

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
        
        // Track actual watch time continuously if playing
        if (player.getPlayerState() === YT.PlayerState.PLAYING) {
          if (watchStartTime) {
            // Check if user is seeking (time jumped)
            if (Math.abs(currentTime - lastKnownTime) > 1.5) {
              console.log('[PROGRESS] Seeking detected, resetting timer');
              watchStartTime = Date.now(); // Reset timer
              totalWatchTime = Math.max(0, totalWatchTime - 2); // Penalize seeking
            }
            lastKnownTime = currentTime;
          }
        }
      }
    }

    // Select lesson
    function selectLesson(lessonId, isLocked) {
      if (!courseData || !courseData.sections) {
        console.log('Course data not loaded yet');
        return;
      }
      
      // Save progress of current lesson before switching
      if (currentLessonId && currentLessonId !== lessonId) {
        checkAndSaveProgress();
      }
      
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
      currentLessonId = lessonId;
      
      // Update UI
      document.getElementById('lessonTitle').textContent = currentLesson.title;
      renderLessons();
      
      // Load video with YouTube IFrame API
      if (currentLesson.type === 'lesson' && currentLesson.videoId) {
        loadVideo(currentLesson.videoId, currentLesson.id);
      }
    }
    
    // Auto-load next lesson after completion
    function autoLoadNextLesson(completedLessonId) {
      if (!courseData || !courseData.sections) {
        return;
      }
      
      // Build flat list
      let allLessons = [];
      courseData.sections.forEach(function(section) {
        section.lessons.forEach(function(lesson) {
          allLessons.push(lesson);
        });
      });
      
      // Find next lesson
      const currentIndex = allLessons.findIndex(function(l) { return l.id === completedLessonId; });
      if (currentIndex >= 0 && currentIndex < allLessons.length - 1) {
        const nextLesson = allLessons[currentIndex + 1];
        setTimeout(function() {
          showNotification('🎯 Đang chuyển sang bài tiếp theo...', 'info');
          setTimeout(function() {
            selectLesson(nextLesson.id, false);
          }, 2000);
        }, 1000);
      } else {
        showNotification('🎉 Chúc mừng! Bạn đã hoàn thành toàn bộ khóa học!', 'success');
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
      if (progressCheckInterval) {
        clearInterval(progressCheckInterval);
      }
      
      // Reset watch time tracking
      watchStartTime = null;
      totalWatchTime = 0;
      lastKnownTime = 0;
      watchedSegments = [];
      
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
            // Set quality to highest available (with error handling)
            try {
              var availableQualityLevels = player.getAvailableQualityLevels();
              if (availableQualityLevels && availableQualityLevels.length > 0) {
                player.setPlaybackQuality(availableQualityLevels[0]); // Set to highest quality
              }
            } catch (e) {
              console.log('[PLAYER] Could not set quality:', e);
            }
            
            // Start progress tracking UI
            progressInterval = setInterval(updateVideoProgress, 1000);
            
            // Start periodic progress check every 10 seconds (reduced frequency to avoid spam)
            progressCheckInterval = setInterval(checkAndSaveProgress, 10000);
          },
          'onStateChange': function(event) {
            // When video starts playing
            if (event.data === YT.PlayerState.PLAYING) {
              const currentTime = player.getCurrentTime();
              console.log('[PLAYER] ▶️ Playing - Lesson:', lessonId, '| Time:', currentTime.toFixed(1) + 's');
              
              // Detect seeking: if current time jumped more than 2 seconds
              if (lastKnownTime > 0 && Math.abs(currentTime - lastKnownTime) > 2) {
                console.log('[PLAYER] 🔍 SEEKING detected! Jumped from', lastKnownTime.toFixed(1) + 's to', currentTime.toFixed(1) + 's');
                // Reset watch timer when seeking
                watchStartTime = null;
              }
              
              if (!watchStartTime) {
                watchStartTime = Date.now();
                console.log('[PLAYER] Started watch timer from', currentTime.toFixed(1) + 's');
              }
              
              lastKnownTime = currentTime;
            }
            
            // When video is paused
            if (event.data === YT.PlayerState.PAUSED) {
              const currentTime = player.getCurrentTime();
              console.log('[PLAYER] ⏸️ Paused at', currentTime.toFixed(1) + 's');
              
              if (watchStartTime) {
                const sessionTime = (Date.now() - watchStartTime) / 1000;
                // Only count if session is reasonable (not a quick pause/play)
                if (sessionTime >= 1) {
                  totalWatchTime += sessionTime;
                  console.log('[PLAYER] Added', sessionTime.toFixed(1) + 's to total. Total now:', totalWatchTime.toFixed(1) + 's');
                }
                watchStartTime = null;
              }
              
              lastKnownTime = currentTime;
            }
            
            // Video ended - save completion and auto-load next
            if (event.data === YT.PlayerState.ENDED) {
              if (watchStartTime) {
                totalWatchTime += (Date.now() - watchStartTime) / 1000;
              }
              
              const duration = player.getDuration();
              const actualWatchPercentage = (totalWatchTime / duration) * 100;
              
              console.log('[ENDED] Video ended - Actual watch time:', totalWatchTime.toFixed(1) + 's /', duration.toFixed(1) + 's', '| Actual percentage:', actualWatchPercentage.toFixed(1) + '%');
              
              // MUST watch at least 80% of video DURATION (not just seek to end)
              if (actualWatchPercentage >= 80) {
                console.log('[ENDED] ✅ Saving completion for lesson', lessonId);
                saveLessonCompletion(lessonId).then(function(result) {
                  console.log('[ENDED] ✅ Save successful, loading next lesson');
                  if (currentLesson) currentLesson.completed = true;
                  
                  // Auto-load next lesson after short delay
                  setTimeout(function() {
                    autoLoadNextLesson(lessonId);
                  }, 1000);
                }).catch(function(error) {
                  console.error('[ENDED] ❌ Save failed:', error);
                  // Still show notification even if save failed
                  showNotification('⚠️ Không thể lưu tiến độ. Vui lòng kiểm tra kết nối.', 'error');
                });
              } else {
                console.log('[ENDED] ❌ Not enough watch time:', actualWatchPercentage.toFixed(1) + '% (need 80%)');
                showNotification('⚠️ Bạn cần xem ít nhất 80% video để hoàn thành bài học. Hiện tại: ' + actualWatchPercentage.toFixed(0) + '%', 'error');
                // Don't auto-load next lesson if not completed
                // User must replay and watch properly
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
      if (!courseData || !courseData.sections) {
        console.log('Course data not loaded yet, skipping progress update');
        return;
      }
      
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
    document.addEventListener('DOMContentLoaded', async function() {
      console.log('=== LEARNING PAGE INIT ===');
      console.log('Course ID:', currentCourseId);
      console.log('User logged in: <%= loggedIn %>');
      console.log('User ID: <%= userId %>');
      
      // Load lessons first, then progress
      console.log('Loading lessons from database...');
      await loadLessons();
      
      console.log('Loading progress from server...');
      await loadCompletedLessons();
      
      renderLessons();
      updateCourseTitle();
      // Load first lesson by default
      if (courseData && courseData.sections && courseData.sections.length > 0 && courseData.sections[0].lessons.length > 0) {
        selectLesson(courseData.sections[0].lessons[0].id, false);
      }
    });
  </script>

  <!-- YouTube IFrame API -->
  <script src="https://www.youtube.com/iframe_api"></script>
  <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
</body>
</html>
