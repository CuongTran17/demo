<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.servlets.TeacherServlet" %>
<%@ page import="com.example.model.PendingChange" %>
<%@ page import="java.math.BigDecimal" %>
<%
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
    String userEmail = (String) session.getAttribute("userEmail");
    String userPhone = (String) session.getAttribute("userPhone");
    String userFullname = (String) session.getAttribute("userFullname");
    
    if (loggedIn == null || !loggedIn) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    // Get data from request attributes
    @SuppressWarnings("unchecked")
    List<TeacherServlet.TeacherCourse> teacherCourses = (List<TeacherServlet.TeacherCourse>) request.getAttribute("teacherCourses");
    @SuppressWarnings("unchecked")
    List<TeacherServlet.StudentInfo> students = (List<TeacherServlet.StudentInfo>) request.getAttribute("students");
    TeacherServlet.CourseStats stats = (TeacherServlet.CourseStats) request.getAttribute("stats");
    
    if (teacherCourses == null) teacherCourses = new java.util.ArrayList<>();
    if (students == null) students = new java.util.ArrayList<>();
    if (stats == null) stats = new TeacherServlet.CourseStats();
    
    // Check for success message
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
        session.removeAttribute("successMessage"); // Clear the message after displaying
    }
%>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <title>Quản lý giáo viên – PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css?v=3" />
  <style>
    .teacher-dashboard {
      padding: 20px 0;
    }
    
    .dashboard-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 30px;
      border-radius: 15px;
      margin-bottom: 30px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    
    .dashboard-header-content h1 {
      margin: 0 0 10px 0;
      font-size: 2.5rem;
      font-weight: 700;
    }
    
    .dashboard-header-content p {
      margin: 0;
      opacity: 0.9;
      font-size: 1.1rem;
    }
    
    .logout-btn {
      background: rgba(255, 255, 255, 0.2);
      color: white;
      border: 2px solid white;
      padding: 12px 30px;
      border-radius: 8px;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      transition: all 0.3s ease;
      text-decoration: none;
      display: inline-block;
    }
    
    .logout-btn:hover {
      background: white;
      color: #667eea;
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    }
    
    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 20px;
      margin-bottom: 40px;
    }
    
    .stat-card {
      background: white;
      padding: 25px;
      border-radius: 12px;
      box-shadow: 0 2px 20px rgba(0,0,0,0.08);
      text-align: center;
      border-left: 4px solid;
    }
    
    .stat-card.courses { border-left-color: #4CAF50; }
    .stat-card.students { border-left-color: #FF9800; }
    .stat-card.revenue { border-left-color: #2196F3; }
    
    .stat-number {
      font-size: 2.5rem;
      font-weight: 700;
      margin-bottom: 8px;
    }
    
    .stat-label {
      color: #666;
      font-size: 0.95rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    
    .tab-navigation {
      display: flex;
      background: white;
      border-radius: 12px;
      padding: 5px;
      margin-bottom: 30px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    }
    
    .tab-button {
      flex: 1;
      padding: 15px 20px;
      border: none;
      background: transparent;
      cursor: pointer;
      border-radius: 8px;
      transition: all 0.3s ease;
      font-weight: 500;
    }
    
    .tab-button.active {
      background: #667eea;
      color: white;
    }
    
    .tab-content {
      display: none;
      background: white;
      border-radius: 12px;
      padding: 30px;
      box-shadow: 0 2px 20px rgba(0,0,0,0.08);
    }
    
    .tab-content.active {
      display: block;
    }
    
    .course-table, .student-table, .data-table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    
    .course-table th, .course-table td,
    .student-table th, .student-table td,
    .data-table th, .data-table td {
      padding: 15px;
      text-align: left;
      border-bottom: 1px solid #eee;
    }
    
    .course-table th, .student-table th, .data-table th {
      background: #f8f9fa;
      font-weight: 600;
      color: #333;
    }
    
    .btn-primary {
      background: #667eea;
      color: white;
      border: none;
      padding: 12px 24px;
      border-radius: 8px;
      cursor: pointer;
      font-weight: 500;
      transition: all 0.3s ease;
    }
    
    .btn-primary:hover {
      background: #5a67d8;
      transform: translateY(-1px);
    }
    
    .btn-secondary {
      background: #e2e8f0;
      color: #4a5568;
      border: none;
      padding: 8px 16px;
      border-radius: 6px;
      cursor: pointer;
      font-size: 0.9rem;
      margin-right: 8px;
      transition: all 0.3s ease;
    }
    
    .btn-secondary:hover {
      background: #cbd5e0;
    }
    
    .btn-danger {
      background: #e53e3e;
      color: white;
    }
    
    .btn-danger:hover {
      background: #c53030;
    }
    
    .form-group {
      margin-bottom: 20px;
    }
    
    .form-group label {
      display: block;
      margin-bottom: 5px;
      font-weight: 500;
      color: #333;
    }
    
    .form-group input, .form-group textarea, .form-group select {
      width: 100%;
      padding: 12px;
      border: 1px solid #e2e8f0;
      border-radius: 8px;
      font-size: 1rem;
      transition: border-color 0.3s ease;
    }
    
    .form-group input:focus, .form-group textarea:focus, .form-group select:focus {
      outline: none;
      border-color: #667eea;
      box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    }
    
    .modal {
      display: none;
      position: fixed;
      z-index: 1000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0,0,0,0.5);
    }
    
    .modal-content {
      background-color: white;
      margin: 5% auto;
      padding: 30px;
      border-radius: 12px;
      width: 90%;
      max-width: 600px;
      max-height: 80vh;
      overflow-y: auto;
    }
    
    .close {
      color: #aaa;
      float: right;
      font-size: 28px;
      font-weight: bold;
      cursor: pointer;
    }
    
    .close:hover {
      color: #000;
    }
    
    .progress-bar {
      width: 100%;
      height: 8px;
      background: #e2e8f0;
      border-radius: 4px;
      overflow: hidden;
    }
    
    .progress-fill {
      height: 100%;
      background: #4CAF50;
      transition: width 0.3s ease;
    }
    
    @media (max-width: 768px) {
      .stats-grid {
        grid-template-columns: 1fr;
      }
      
      .tab-navigation {
        flex-direction: column;
      }
      
      .dashboard-header {
        padding: 20px;
      }
      
      .dashboard-header h1 {
        font-size: 1.5rem;
      }
      
      .teacher-dashboard {
        padding: 10px;
      }
      
      .course-table, .student-table, .data-table {
        font-size: 0.9rem;
        overflow-x: auto;
        -webkit-overflow-scrolling: touch;
        display: block;
      }
      
      .course-table th, .course-table td,
      .student-table th, .student-table td,
      .data-table th, .data-table td {
        padding: 10px;
        white-space: nowrap;
      }
    }
    
    /* Badge styles */
    .badge {
      display: inline-block;
      padding: 4px 8px;
      border-radius: 4px;
      font-size: 0.8rem;
      font-weight: 500;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    
    .badge-success {
      background-color: #d4edda;
      color: #155724;
      border: 1px solid #c3e6cb;
    }
    
    .badge-warning {
      background-color: #fff3cd;
      color: #856404;
      border: 1px solid #ffeaa7;
    }
    
    .badge-danger {
      background-color: #f8d7da;
      color: #721c24;
      border: 1px solid #f5c6cb;
    }
    
    .badge-info {
      background-color: #d1ecf1;
      color: #0c5460;
      border: 1px solid #bee5eb;
    }
  </style>
</head>
<body>
  <%@ include file="/includes/header.jsp" %>

  <main class="container teacher-dashboard">
    <div class="dashboard-header">
      <div class="dashboard-header-content">
        <h1>👨‍🏫 Bảng điều khiển giáo viên</h1>
        <p>Chào mừng <%= userFullname != null ? userFullname : "Giáo viên" %> đến với hệ thống quản lý khóa học</p>
      </div>
      <a href="${pageContext.request.contextPath}/logout" class="logout-btn">🚪 Đăng xuất</a>
    </div>

    <!-- Statistics -->
    <div class="stats-grid">
      <div class="stat-card courses">
        <div class="stat-number"><%= stats.totalCourses %></div>
        <div class="stat-label">Khóa học</div>
      </div>
      <div class="stat-card students">
        <div class="stat-number"><%= stats.totalStudents %></div>
        <div class="stat-label">Học viên</div>
      </div>
      <div class="stat-card revenue">
        <div class="stat-number"><%= String.format("%,d", stats.totalRevenue.longValue()) %>₫</div>
        <div class="stat-label">Doanh thu</div>
      </div>
    </div>

    <!-- Tab Navigation -->
    <div class="tab-navigation">
      <button class="tab-button active" onclick="showTab('courses')">📚 Quản lý khóa học</button>
      <button class="tab-button" onclick="showTab('students')">👥 Quản lý học viên</button>
      <button class="tab-button" onclick="showTab('content')">📝 Quản lý nội dung</button>
      <button class="tab-button" onclick="showTab('analytics')">📊 Thống kê</button>
      <button class="tab-button" onclick="showTab('pending')">
        ⏳ Duyệt thay đổi
        <% 
        @SuppressWarnings("unchecked")
        List<PendingChange> allPendingChanges = (List<PendingChange>) request.getAttribute("pendingChanges");
        int pendingCount = 0;
        if (allPendingChanges != null) {
          for (PendingChange pc : allPendingChanges) {
            if ("pending".equals(pc.getStatus())) {
              pendingCount++;
            }
          }
        }
        if (pendingCount > 0) {
          out.print("<span class='badge badge-warning' style='margin-left: 8px;'>" + pendingCount + "</span>");
        }
        %>
      </button>
    </div>

    <!-- Courses Tab -->
    <div class="tab-content active" id="courses-tab">
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <h2>Quản lý khóa học</h2>
        <button class="btn-primary" onclick="openModal('createCourseModal')">➕ Tạo khóa học mới</button>
      </div>
      
      <table class="course-table">
        <thead>
          <tr>
            <th>Tên khóa học</th>
            <th>Danh mục</th>
            <th>Giá</th>
            <th>Học viên</th>
            <th>Thao tác</th>
          </tr>
        </thead>
        <tbody>
          <% for (TeacherServlet.TeacherCourse course : teacherCourses) { %>
          <tr data-course-id="<%= course.courseId %>" 
              data-course-name="<%= course.courseName %>" 
              data-course-description="<%= course.description != null ? course.description.replaceAll("\"", "&quot;") : "" %>" 
              data-course-price="<%= course.price.longValue() %>"
              data-course-thumbnail="<%= course.thumbnail != null ? course.thumbnail : "" %>">
            <td>
              <strong><%= course.courseName %></strong>
              <br><small style="color: #666;"><%= course.description != null ? course.description.substring(0, Math.min(course.description.length(), 60)) + "..." : "" %></small>
            </td>
            <td><%= course.category %></td>
            <td><%= String.format("%,d", course.price.longValue()) %>₫</td>
            <td><%= course.enrolledCount %> học viên</td>
            <td>
              <button class="btn-secondary" onclick="editCourse('<%= course.courseId %>')">✏️ Sửa</button>
              <button class="btn-secondary btn-danger" onclick="deleteCourse('<%= course.courseId %>')">🗑️ Xóa</button>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>

    <!-- Students Tab -->
    <div class="tab-content" id="students-tab">
      <h2>Quản lý học viên</h2>
      
      <table class="student-table">
        <thead>
          <tr>
            <th>Học viên</th>
            <th>Khóa học</th>
            <th>Ngày đăng ký</th>
            <th>Tiến độ</th>
            <th>Thao tác</th>
          </tr>
        </thead>
        <tbody>
          <% for (TeacherServlet.StudentInfo student : students) { %>
          <tr>
            <td>
              <strong><%= student.fullname %></strong>
              <br><small style="color: #666;"><%= student.email %></small>
            </td>
            <td><%= student.courseName %></td>
            <td><%= new java.text.SimpleDateFormat("dd/MM/yyyy").format(student.enrolledDate) %></td>
            <td>
              <div class="progress-bar">
                <div class="progress-fill" style="width: <%= student.progress %>%;"></div>
              </div>
              <small><%= student.progress %>% hoàn thành</small>
            </td>
            <td>
              <button class="btn-secondary" onclick="viewStudent(<%= student.userId %>)">👁️ Xem</button>
              <button class="btn-secondary" onclick="messageStudent(<%= student.userId %>)">💬 Nhắn tin</button>
            </td>
          </tr>
          <% } %>
        </tbody>
      </table>
    </div>

    <!-- Content Tab -->
    <div class="tab-content" id="content-tab">
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <h2>Quản lý nội dung bài học</h2>
        <button class="btn-primary" onclick="openModal('createLessonModal')">➕ Tạo bài học mới</button>
      </div>
      
      <div class="form-group">
        <label>Chọn khóa học:</label>
        <select id="courseSelect" onchange="loadLessons()">
          <option value="">-- Chọn khóa học --</option>
          <% for (TeacherServlet.TeacherCourse course : teacherCourses) { %>
          <option value="<%= course.courseId %>"><%= course.courseName %></option>
          <% } %>
        </select>
      </div>
      
      <div id="lessonsContainer">
        <p style="text-align: center; color: #666; padding: 40px;">Vui lòng chọn khóa học để xem nội dung bài học</p>
      </div>
    </div>

    <!-- Analytics Tab -->
    <div class="tab-content" id="analytics-tab">
      <h2>Thống kê chi tiết</h2>
      
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-number"><%= teacherCourses.size() %></div>
          <div class="stat-label">Khóa học đang giảng dạy</div>
        </div>
        <div class="stat-card">
          <div class="stat-number"><%= students.size() %></div>
          <div class="stat-label">Tổng lượt đăng ký</div>
        </div>
        <div class="stat-card">
          <div class="stat-number">
            <% 
            int totalProgress = 0;
            int studentCount = students.size();
            for (TeacherServlet.StudentInfo student : students) {
                totalProgress += student.progress;
            }
            int avgProgress = studentCount > 0 ? totalProgress / studentCount : 0;
            %>
            <%= avgProgress %>%
          </div>
          <div class="stat-label">Tiến độ trung bình</div>
        </div>
      </div>
      
      <div style="background: white; padding: 20px; border-radius: 12px; margin-top: 20px;">
        <h3>Hiệu suất khóa học</h3>
        <% for (TeacherServlet.TeacherCourse course : teacherCourses) { %>
        <div style="margin-bottom: 15px;">
          <div style="display: flex; justify-content: space-between; margin-bottom: 5px;">
            <span><%= course.courseName %></span>
            <span><%= course.enrolledCount %> học viên</span>
          </div>
          <div class="progress-bar">
            <div class="progress-fill" style="width: <%= Math.min(course.enrolledCount * 10, 100) %>%;"></div>
          </div>
        </div>
        <% } %>
      </div>
    </div>

    <!-- Pending Changes Tab -->
    <div class="tab-content" id="pending-tab">
      <h2>Yêu cầu duyệt thay đổi</h2>
      
      <div class="data-table">
        <table>
          <thead>
            <tr>
              <th>ID</th>
              <th>Loại thay đổi</th>
              <th>Đối tượng</th>
              <th>Nội dung thay đổi</th>
              <th>Trạng thái</th>
              <th>Ngày gửi</th>
              <th>Ngày duyệt</th>
              <th>Người duyệt</th>
              <th>Ghi chú</th>
            </tr>
          </thead>
          <tbody>
            <% 
            @SuppressWarnings("unchecked")
            List<PendingChange> pendingChanges = (List<PendingChange>) request.getAttribute("pendingChanges");
            if (pendingChanges != null) {
              for (PendingChange change : pendingChanges) { 
            %>
            <tr>
              <td><%= change.getChangeId() %></td>
              <td>
                <span class="badge badge-info">
                  <% 
                  String type = change.getChangeType();
                  if ("course_create".equals(type)) out.print("Tạo khóa học");
                  else if ("course_update".equals(type)) out.print("Cập nhật khóa học");
                  else if ("lesson_create".equals(type)) out.print("Tạo bài học");
                  else if ("lesson_update".equals(type)) out.print("Cập nhật bài học");
                  else if ("lesson_delete".equals(type)) out.print("Xóa bài học");
                  else out.print(type);
                  %>
                </span>
              </td>
              <td><%= change.getTargetId() %></td>
              <td>
                <div style="max-width: 250px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" 
                     title="<%= change.getChangeData() %>">
                  <%= change.getChangeData() %>
                </div>
              </td>
              <td>
                <% 
                String status = change.getStatus();
                String statusClass = "badge-warning";
                String statusText = "Chờ duyệt";
                if ("approved".equals(status)) {
                  statusClass = "badge-success";
                  statusText = "Đã duyệt";
                } else if ("rejected".equals(status)) {
                  statusClass = "badge-danger";
                  statusText = "Từ chối";
                }
                %>
                <span class="badge <%= statusClass %>"><%= statusText %></span>
              </td>
              <td><%= change.getCreatedAt() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(change.getCreatedAt()) : "-" %></td>
              <td><%= change.getReviewedAt() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(change.getReviewedAt()) : "-" %></td>
              <td><%= change.getReviewerName() != null ? change.getReviewerName() : "-" %></td>
              <td><%= change.getReviewNote() != null ? change.getReviewNote() : "-" %></td>
            </tr>
            <% } } %>
          </tbody>
        </table>
      </div>
      
      <% if (pendingChanges == null || pendingChanges.isEmpty()) { %>
      <div style="text-align: center; padding: 40px; color: #666;">
        <p>Chưa có yêu cầu duyệt thay đổi nào.</p>
      </div>
      <% } %>
    </div>
  </main>

  <!-- Create Course Modal -->
  <div id="createCourseModal" class="modal">
    <div class="modal-content">
      <span class="close" onclick="closeModal('createCourseModal')">&times;</span>
      <h2>Tạo khóa học mới</h2>
      <form method="post" action="${pageContext.request.contextPath}/teacher">
        <input type="hidden" name="action" value="createCourse">
        
        <div class="form-group">
          <label>ID khóa học:</label>
          <input type="text" name="courseId" required placeholder="vd: python-advanced">
        </div>
        
        <div class="form-group">
          <label>Tên khóa học:</label>
          <input type="text" name="courseName" required placeholder="vd: Python nâng cao">
        </div>
        
        <div class="form-group">
          <label>Danh mục:</label>
          <select name="category" required>
            <option value="">-- Chọn danh mục --</option>
            <option value="python">Lập trình Python</option>
            <option value="finance">Tài chính</option>
            <option value="data">Phân tích dữ liệu</option>
            <option value="blockchain">Blockchain</option>
            <option value="accounting">Kế toán</option>
            <option value="marketing">Marketing</option>
          </select>
        </div>
        
        <div class="form-group">
          <label>Mô tả:</label>
          <textarea name="description" rows="4" placeholder="Mô tả chi tiết về khóa học..."></textarea>
        </div>
        
        <div class="form-group">
          <label>Giá (VNĐ):</label>
          <input type="number" name="price" required placeholder="vd: 1500000">
        </div>
        
        <button type="submit" class="btn-primary">Tạo khóa học</button>
      </form>
    </div>
  </div>

  <!-- Edit Course Modal -->
  <div id="editCourseModal" class="modal">
    <div class="modal-content">
      <span class="close" onclick="closeModal('editCourseModal')">&times;</span>
      <h2>Chỉnh sửa khóa học</h2>
      
      <!-- Form for text fields -->
      <form id="editCourseForm" method="post" action="${pageContext.request.contextPath}/teacher">
        <input type="hidden" name="action" value="updateCourse">
        <input type="hidden" id="editCourseId" name="courseId">
        
        <div class="form-group">
          <label>Tên khóa học:</label>
          <input type="text" id="editCourseName" name="courseName" required placeholder="vd: Python nâng cao">
        </div>
        
        <div class="form-group">
          <label>Mô tả:</label>
          <textarea id="editCourseDescription" name="description" rows="4" placeholder="Mô tả chi tiết về khóa học..."></textarea>
        </div>
        
        <div class="form-group">
          <label>Giá (VNĐ):</label>
          <input type="number" id="editCoursePrice" name="price" required placeholder="vd: 1500000">
        </div>
        
        <button type="submit" class="btn-primary">💾 Lưu thay đổi</button>
      </form>
      
      <hr style="margin: 30px 0; border: 1px solid #e2e8f0;">
      
      <!-- Separate form for image upload -->
      <div class="form-group">
        <label>Ảnh khóa học hiện tại:</label>
        <div id="currentThumbnailContainer" style="margin-top: 10px;">
          <img id="currentThumbnail" src="" alt="Current thumbnail" style="max-width: 200px; max-height: 150px; border-radius: 8px; display: none;">
          <p id="noThumbnailText" style="color: #666; font-style: italic;">Chưa có ảnh</p>
        </div>
      </div>
      
      <div class="form-group">
        <label>Tải ảnh mới (nếu muốn thay đổi):</label>
        <input type="file" id="courseImageUpload" accept="image/*" style="padding: 10px;">
        <small style="color: #666; display: block; margin-top: 5px;">Chọn file ảnh (JPG, PNG, max 10MB)</small>
      </div>
      
      <div id="uploadProgress" style="display: none; margin: 15px 0;">
        <div style="background: #e2e8f0; height: 8px; border-radius: 4px; overflow: hidden;">
          <div id="uploadProgressBar" style="background: #667eea; height: 100%; width: 0%; transition: width 0.3s;"></div>
        </div>
        <p id="uploadStatus" style="margin-top: 5px; color: #666; font-size: 0.9rem;"></p>
      </div>
    </div>
  </div>

  <!-- Create Lesson Modal -->
  <div id="createLessonModal" class="modal">
    <div class="modal-content">
      <span class="close" onclick="closeModal('createLessonModal')">&times;</span>
      <h2>Tạo bài học mới</h2>
      <form method="post" action="${pageContext.request.contextPath}/teacher">
        <input type="hidden" name="action" value="createLesson">
        
        <div class="form-group">
          <label>Khóa học:</label>
          <select name="courseId" required>
            <option value="">-- Chọn khóa học --</option>
            <% for (TeacherServlet.TeacherCourse course : teacherCourses) { %>
            <option value="<%= course.courseId %>"><%= course.courseName %></option>
            <% } %>
          </select>
        </div>
        
        <div class="form-group">
          <label>Phần:</label>
          <input type="number" name="sectionId" value="1" min="1" required>
        </div>
        
        <div class="form-group">
          <label>Thứ tự bài học:</label>
          <input type="number" name="lessonOrder" value="1" min="1" required>
        </div>
        
        <div class="form-group">
          <label>Tiêu đề bài học:</label>
          <input type="text" name="lessonTitle" required placeholder="vd: Giới thiệu về Python">
        </div>
        
        <div class="form-group">
          <label>Nội dung:</label>
          <textarea name="lessonContent" rows="5" placeholder="Nội dung chi tiết bài học..."></textarea>
        </div>
        
        <div class="form-group">
          <label>URL Video:</label>
          <input type="url" name="videoUrl" placeholder="https://youtube.com/watch?v=...">
        </div>
        
        <div class="form-group">
          <label>Thời lượng:</label>
          <input type="text" name="duration" placeholder="vd: 15:30">
        </div>
        
        <button type="submit" class="btn-primary">Tạo bài học</button>
      </form>
    </div>
  </div>

  <!-- Edit Lesson Modal -->
  <div id="editLessonModal" class="modal">
    <div class="modal-content">
      <span class="close" onclick="closeModal('editLessonModal')">&times;</span>
      <h2>✏️ Chỉnh sửa bài học</h2>
      <form method="post" action="${pageContext.request.contextPath}/teacher">
        <input type="hidden" name="action" value="updateLesson">
        <input type="hidden" id="editLessonId" name="lessonId">
        <input type="hidden" id="editLessonCourseId" name="courseId">
        
        <div class="form-group">
          <label>Phần:</label>
          <input type="number" id="editLessonSection" name="sectionId" min="1" required>
        </div>
        
        <div class="form-group">
          <label>Thứ tự bài học:</label>
          <input type="number" id="editLessonOrder" name="lessonOrder" min="1" required>
        </div>
        
        <div class="form-group">
          <label>Tiêu đề bài học: <span style="color: red;">*</span></label>
          <input type="text" id="editLessonTitle" name="lessonTitle" required placeholder="vd: Giới thiệu về Python">
        </div>
        
        <div class="form-group">
          <label>Nội dung:</label>
          <textarea id="editLessonContent" name="lessonContent" rows="5" placeholder="Nội dung chi tiết bài học..."></textarea>
        </div>
        
        <div class="form-group">
          <label>URL Video (YouTube): <span style="color: red;">*</span></label>
          <input type="url" id="editLessonVideoUrl" name="videoUrl" required placeholder="https://youtube.com/watch?v=...">
          <small style="color: #666; display: block; margin-top: 5px;">💡 Nhập link YouTube để nhúng video vào bài học</small>
        </div>
        
        <div class="form-group">
          <label>Thời lượng:</label>
          <input type="text" id="editLessonDuration" name="duration" placeholder="vd: 15:30">
        </div>
        
        <div style="display: flex; gap: 10px;">
          <button type="submit" class="btn-primary" style="flex: 1;">✅ Lưu thay đổi</button>
          <button type="button" class="btn-secondary" style="flex: 1;" onclick="closeModal('editLessonModal')">Hủy</button>
        </div>
      </form>
    </div>
  </div>

  <script>
    function showTab(tabName) {
      // Hide all tabs
      document.querySelectorAll('.tab-content').forEach(tab => {
        tab.classList.remove('active');
      });
      
      // Remove active class from all buttons
      document.querySelectorAll('.tab-button').forEach(btn => {
        btn.classList.remove('active');
      });
      
      // Show selected tab
      document.getElementById(tabName + '-tab').classList.add('active');
      event.target.classList.add('active');
    }
    
    function openModal(modalId) {
      document.getElementById(modalId).style.display = 'block';
    }
    
    function closeModal(modalId) {
      document.getElementById(modalId).style.display = 'none';
    }
    
    function editCourse(courseId) {
      // Get course data from table row data attributes
      const row = document.querySelector('tr[data-course-id="' + courseId + '"]');
      if (row) {
        document.getElementById('editCourseId').value = row.getAttribute('data-course-id');
        document.getElementById('editCourseName').value = row.getAttribute('data-course-name');
        document.getElementById('editCourseDescription').value = row.getAttribute('data-course-description').replace(/&quot;/g, '"');
        document.getElementById('editCoursePrice').value = row.getAttribute('data-course-price');
        
        // Display current thumbnail if exists
        const thumbnail = row.getAttribute('data-course-thumbnail');
        const currentImg = document.getElementById('currentThumbnail');
        const noThumbnailText = document.getElementById('noThumbnailText');
        
        if (thumbnail && thumbnail !== 'null' && thumbnail.trim() !== '') {
          currentImg.src = thumbnail;
          currentImg.style.display = 'block';
          noThumbnailText.style.display = 'none';
        } else {
          currentImg.style.display = 'none';
          noThumbnailText.style.display = 'block';
        }
        
        openModal('editCourseModal');
      }
    }
    
    // Handle image upload when file is selected
    document.addEventListener('DOMContentLoaded', function() {
      const uploadInput = document.getElementById('courseImageUpload');
      if (uploadInput) {
        uploadInput.addEventListener('change', function() {
          if (this.files && this.files[0]) {
            const courseId = document.getElementById('editCourseId').value;
            if (!courseId) {
              alert('Vui lòng chọn khóa học trước');
              this.value = '';
              return;
            }
            
            uploadCourseImage(this.files[0], courseId);
          }
        });
      }
    });
    
    function uploadCourseImage(file, courseId) {
      // Validate file size (max 10MB)
      if (file.size > 10 * 1024 * 1024) {
        alert('File quá lớn! Vui lòng chọn file nhỏ hơn 10MB.');
        return;
      }
      
      // Validate file type
      if (!file.type.startsWith('image/')) {
        alert('Vui lòng chọn file ảnh (JPG, PNG, etc.)');
        return;
      }
      
      // Show progress bar
      const progressDiv = document.getElementById('uploadProgress');
      const progressBar = document.getElementById('uploadProgressBar');
      const statusText = document.getElementById('uploadStatus');
      
      progressDiv.style.display = 'block';
      progressBar.style.width = '30%';
      statusText.textContent = 'Đang đọc file...';
      statusText.style.color = '#666';
      progressBar.style.background = '#667eea';
      
      // Read file as base64
      const reader = new FileReader();
      
      reader.onload = function(e) {
        const base64Data = e.target.result;
        
        progressBar.style.width = '60%';
        statusText.textContent = 'Đang tải lên...';
        
        // Send to teacher servlet with uploadImage action
        const formData = new URLSearchParams();
        formData.append('action', 'uploadImage');
        formData.append('courseId', courseId);
        formData.append('imageUrl', base64Data);
        
        fetch('${pageContext.request.contextPath}/teacher', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: formData.toString()
        })
        .then(response => {
          console.log('Upload response status:', response.status);
          return response.json();
        })
        .then(data => {
          console.log('Upload response:', data);
          
          if (data.success) {
            progressBar.style.width = '100%';
            progressBar.style.background = '#48bb78';
            statusText.textContent = '✓ Tải lên thành công!';
            statusText.style.color = '#48bb78';
            
            // Update current thumbnail preview
            const currentImg = document.getElementById('currentThumbnail');
            const noThumbnailText = document.getElementById('noThumbnailText');
            currentImg.src = data.thumbnailUrl;
            currentImg.style.display = 'block';
            noThumbnailText.style.display = 'none';
            
            // Update the table row data attribute
            const row = document.querySelector('tr[data-course-id="' + courseId + '"]');
            if (row) {
              row.setAttribute('data-course-thumbnail', data.thumbnailUrl);
            }
            
            setTimeout(function() {
              progressDiv.style.display = 'none';
              document.getElementById('courseImageUpload').value = '';
            }, 2000);
          } else {
            progressBar.style.background = '#f56565';
            statusText.textContent = '✗ Lỗi: ' + (data.message || 'Unknown error');
            statusText.style.color = '#f56565';
          }
        })
        .catch(error => {
          console.error('Upload error:', error);
          progressBar.style.background = '#f56565';
          statusText.textContent = '✗ Lỗi kết nối: ' + error.message;
          statusText.style.color = '#f56565';
        });
      };
      
      reader.onerror = function() {
        progressBar.style.background = '#f56565';
        statusText.textContent = '✗ Lỗi đọc file';
        statusText.style.color = '#f56565';
      };
      
      reader.readAsDataURL(file);
    }
    
    function deleteCourse(courseId) {
      if (confirm('Bạn có chắc chắn muốn xóa khóa học này?')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/teacher';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'deleteCourse';
        
        const courseInput = document.createElement('input');
        courseInput.type = 'hidden';
        courseInput.name = 'courseId';
        courseInput.value = courseId;
        
        form.appendChild(actionInput);
        form.appendChild(courseInput);
        document.body.appendChild(form);
        form.submit();
      }
    }
    
    function viewStudent(studentId) {
      alert('Chức năng xem chi tiết học viên đang được phát triển!');
    }
    
    function messageStudent(studentId) {
      alert('Chức năng nhắn tin học viên đang được phát triển!');
    }
    
    function loadLessons() {
      const courseId = document.getElementById('courseSelect').value;
      if (!courseId) {
        document.getElementById('lessonsContainer').innerHTML = 
          '<p style="text-align: center; color: #666; padding: 40px;">Vui lòng chọn khóa học để xem nội dung bài học</p>';
        return;
      }
      
      document.getElementById('lessonsContainer').innerHTML = 
        '<p style="text-align: center; color: #666; padding: 40px;">Đang tải nội dung bài học...</p>';
      
      // Load lessons from API
      fetch('${pageContext.request.contextPath}/api/lessons?courseId=' + courseId)
        .then(response => response.json())
        .then(lessons => {
          if (!lessons || lessons.length === 0) {
            document.getElementById('lessonsContainer').innerHTML = 
              '<p style="text-align: center; color: #666; padding: 40px;">Chưa có bài học nào. Hãy tạo bài học đầu tiên!</p>';
            return;
          }
          
          // Build table HTML
          let html = '<table class="data-table"><thead><tr>';
          html += '<th>STT</th><th>Tiêu đề bài học</th><th>Phần</th><th>Video</th><th>Thời lượng</th><th>Thao tác</th>';
          html += '</tr></thead><tbody>';
          
          lessons.forEach((lesson, index) => {
            html += '<tr>';
            html += '<td>' + (index + 1) + '</td>';
            html += '<td><strong>' + lesson.lessonTitle + '</strong></td>';
            html += '<td>Section ' + lesson.sectionId + '</td>';
            html += '<td>' + (lesson.videoUrl ? '✅ Có' : '❌ Không') + '</td>';
            html += '<td>' + (lesson.duration || 'N/A') + '</td>';
            html += '<td>';
            html += '<button class="btn-secondary btn-sm" onclick="editLesson(' + lesson.lessonId + ', \'' + courseId + '\')"><svg width="16" height="16" fill="currentColor"><path d="M12.146.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1 0 .708l-10 10a.5.5 0 0 1-.168.11l-5 2a.5.5 0 0 1-.65-.65l2-5a.5.5 0 0 1 .11-.168l10-10zM11.207 2.5 13.5 4.793 14.793 3.5 12.5 1.207 11.207 2.5zm1.586 3L10.5 3.207 4 9.707V10h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.293l6.5-6.5zm-9.761 5.175-.106.106-1.528 3.821 3.821-1.528.106-.106A.5.5 0 0 1 5 12.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.468-.325z"/></svg> Sửa</button> ';
            html += '<button class="btn-danger btn-sm" onclick="deleteLesson(' + lesson.lessonId + ', \'' + courseId + '\')"><svg width="16" height="16" fill="currentColor"><path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/><path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/></svg> Xóa</button>';
            html += '</td>';
            html += '</tr>';
          });
          
          html += '</tbody></table>';
          document.getElementById('lessonsContainer').innerHTML = html;
        })
        .catch(error => {
          console.error('Error loading lessons:', error);
          document.getElementById('lessonsContainer').innerHTML = 
            '<p style="text-align: center; color: #f56565; padding: 40px;">❌ Lỗi tải dữ liệu: ' + error.message + '</p>';
        });
    }
    
    function editLesson(lessonId, courseId) {
      // Fetch lesson data
      fetch('${pageContext.request.contextPath}/api/lessons?courseId=' + courseId)
        .then(response => response.json())
        .then(lessons => {
          const lesson = lessons.find(l => l.lessonId == lessonId);
          if (!lesson) {
            alert('Không tìm thấy bài học!');
            return;
          }
          
          // Populate edit form
          document.getElementById('editLessonId').value = lesson.lessonId;
          document.getElementById('editLessonCourseId').value = courseId;
          document.getElementById('editLessonSection').value = lesson.sectionId || 1;
          document.getElementById('editLessonOrder').value = lesson.lessonOrder || 1;
          document.getElementById('editLessonTitle').value = lesson.lessonTitle || '';
          document.getElementById('editLessonContent').value = lesson.lessonContent || '';
          document.getElementById('editLessonVideoUrl').value = lesson.videoUrl || '';
          document.getElementById('editLessonDuration').value = lesson.duration || '';
          
          // Show modal
          document.getElementById('editLessonModal').style.display = 'block';
        })
        .catch(error => {
          console.error('Error loading lesson:', error);
          alert('Lỗi tải dữ liệu bài học!');
        });
    }
    
    function deleteLesson(lessonId, courseId) {
      if (!confirm('Bạn có chắc chắn muốn xóa bài học này?')) {
        return;
      }
      
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = '${pageContext.request.contextPath}/teacher';
      
      const actionInput = document.createElement('input');
      actionInput.type = 'hidden';
      actionInput.name = 'action';
      actionInput.value = 'deleteLesson';
      
      const lessonInput = document.createElement('input');
      lessonInput.type = 'hidden';
      lessonInput.name = 'lessonId';
      lessonInput.value = lessonId;
      
      const courseInput = document.createElement('input');
      courseInput.type = 'hidden';
      courseInput.name = 'courseId';
      courseInput.value = courseId;
      
      form.appendChild(actionInput);
      form.appendChild(lessonInput);
      form.appendChild(courseInput);
      document.body.appendChild(form);
      form.submit();
    }
    
    // Close modal when clicking outside
    window.onclick = function(event) {
      if (event.target.classList.contains('modal')) {
        event.target.style.display = 'none';
      }
    }
    
    // Show success message popup
    <% if (successMessage != null) { %>
    window.onload = function() {
      const msg = '<%= successMessage.replace("'", "\\'") %>';
      console.log('Success message:', msg);
      showSuccessPopup(msg);
    }
    <% } %>
    
    function showSuccessPopup(message) {
      console.log('showSuccessPopup called with:', message);
      // Create popup element
      const popup = document.createElement('div');
      popup.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #4CAF50;
        color: white;
        padding: 16px 24px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        z-index: 10000;
        font-family: 'Be Vietnam Pro', sans-serif;
        font-size: 15px;
        font-weight: 500;
        max-width: 400px;
        animation: slideIn 0.3s ease-out;
      `;
      
      // Create inner HTML using DOM methods instead of template literal
      const container = document.createElement('div');
      container.style.cssText = 'display: flex; align-items: center; gap: 12px;';
      
      const checkmark = document.createElement('span');
      checkmark.style.cssText = 'font-size: 20px; font-weight: bold;';
      checkmark.textContent = '✓';
      
      const messageSpan = document.createElement('span');
      messageSpan.style.cssText = 'flex: 1;';
      messageSpan.textContent = message;
      
      const closeBtn = document.createElement('button');
      closeBtn.style.cssText = 'background: none; border: none; color: white; cursor: pointer; font-size: 20px; margin-left: 8px; padding: 0; line-height: 1;';
      closeBtn.textContent = '×';
      closeBtn.onclick = function() { popup.remove(); };
      
      container.appendChild(checkmark);
      container.appendChild(messageSpan);
      container.appendChild(closeBtn);
      popup.appendChild(container);
      
      document.body.appendChild(popup);
      
      // Auto remove after 5 seconds
      setTimeout(() => {
        if (popup.parentElement) {
          popup.style.animation = 'slideOut 0.3s ease-out';
          setTimeout(() => popup.remove(), 300);
        }
      }, 5000);
    }
    
    // Add CSS animations
    const style = document.createElement('style');
    style.textContent = `
      @keyframes slideIn {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
      }
      @keyframes slideOut {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
      }
    `;
    document.head.appendChild(style);
  </script>
</body>
</html>