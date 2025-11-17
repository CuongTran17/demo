<!-- =============================
   File: src/main/webapp/blog.jsp
   Blog article page
   ============================= -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover" />
  <title>Blog – PTIT LEARNING</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/styles.css" />
</head>
<body>
  <%@ include file="/includes/header.jsp" %>

  <main class="container article">
    <h1 class="article-title">Bài viết của chúng tôi</h1>

    <figure class="article-cover">
      <img src="${pageContext.request.contextPath}/assets/img/blog/blog-cover.png" alt="Ảnh bìa bài viết" />
    </figure>

    <div class="article-meta">
      <span>Ngày đăng: 20/10/2025</span>
      <span>•</span>
      <span>Tác giả: PTIT Learning Team</span>
    </div>

    <div class="article-body">
      <p><b>Con Đường Của Một Developer Hiện Đại: Không Chỉ Là Code</b></p>
      <p>Tuyệt vời và hiệu quả, sự nổi lên của lập trình đã tạo ra một kỷ nguyên mới. Đừng chỉ dừng lại ở cú pháp! Chúng ta đang bước vào không gian của kiến trúc phần mềm tinh tế (software architecture), nơi mà hiệu suất tối ưu và trải nghiệm người dùng (UX) là yếu tố sống còn. Từ những dự án farm-to-table (nông trại đến bàn ăn) dùng blockchain, cho đến các hệ thống AI đột phá, lập trình không còn là hoạt động đơn lẻ. Không có sự gián đoạn, chỉ có sự tiến hóa liên tục trong các công cụ, framework (ví dụ: React, Vue, Koci) và phương pháp luận Agile. Phát triển phần mềm hiện đại là sự kết hợp giữa kỹ thuật chuyên sâu và tư duy giải quyết vấn đề.</p>

      <div class="article-gallery">
        <img src="${pageContext.request.contextPath}/assets/img/blog/gallery-1.png" alt="Hình minh hoạ 1" />
        <img src="${pageContext.request.contextPath}/assets/img/blog/gallery-2.png" alt="Hình minh hoạ 2" />
      </div>

      <p><b>Giải Mã Bí Ẩn: Từ Thuật Toán Đến Sản Phẩm Cuối Cùng</b></p>
      <p>Tinh tế, sắc sảo và biểu tượng, thuật toán tiên tiến là "linh hồn" của mọi ứng dụng. Hãy tưởng tượng việc viết code như pha một ly Espresso hoàn hảo—mọi bước đều phải chính xác. Từ việc phân tích dữ liệu lớn (Big Data) đến việc thiết kế API tốc độ cao, quá trình này đòi hỏi sự tỉ mỉ của người thợ thủ công. Đánh giá của người dùng (ratings) là thước đo cuối cùng. Điều gì tạo nên một lập trình viên xuất sắc? Đó là khả năng chuyển hóa những ý tưởng phức tạp thành một giải pháp thanh lịch và dễ bảo trì (maintainable). Hãy dấn thân vào những thử thách của Data Structures và Design Patterns để nâng cấp tư duy của bạn.</p>
    </div>

    <section class="related">
      <h2 class="related-title">Các bài viết liên quan/khác</h2>
      <div class="grid grid-3">
        <article class="card">
          <img src="${pageContext.request.contextPath}/assets/img/blog/related-1.png" alt="Bài viết liên quan 1" class="card-img" />
          <div class="card-body">
            <h3 class="card-title">Sự thay đổi của thông tư 200</h3>
            <p class="card-text">Simon Do</p>
          </div>
        </article>
        <article class="card">
          <img src="${pageContext.request.contextPath}/assets/img/blog/related-2.png" alt="Bài viết liên quan 2" class="card-img" />
          <div class="card-body">
            <h3 class="card-title">Dev tool cùng chúng tôi</h3>
            <p class="card-text">Hachan</p>
          </div>
        </article>
        <article class="card">
          <img src="${pageContext.request.contextPath}/assets/img/blog/related-3.png" alt="Bài viết liên quan 3" class="card-img" />
          <div class="card-body">
            <h3 class="card-title">Marketing trong thời đại số</h3>
            <p class="card-text">Jollie Pham</p>
          </div>
        </article>
      </div>
    </section>
  </main>

  <%@ include file="/includes/footer.jsp" %>

  <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
</body>
</html>
