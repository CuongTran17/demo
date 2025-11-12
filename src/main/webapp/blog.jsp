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
      <img src="${pageContext.request.contextPath}/assets/img/article-cover.jpg" alt="Ảnh bìa bài viết" />
    </figure>

    <div class="article-meta">
      <span>Ngày đăng: 20/10/2025</span>
      <span>•</span>
      <span>Tác giả: PTIT Learning Team</span>
    </div>

    <div class="article-body">
      <p>Body text for your whole article or post. We put in some lorem ipsum to show how a filled-out page might look.</p>
      <p>Exceptiont efficient emerging, elitism veniam anim adfae carefully curated ciorona conversation specialty perfect nosedivian farm-to-table, elit icelandic farm fresh cillum. Nulla disruptibles, essential kogi. Bespoke cliche tumeric blog live.</p>
      <p>Exquisite sophisticated iconic cutting-edge liqueur dessert lorem ipsum dolor sit amet. Sharp affogato artisan chambray freshly roasted arabica delightful. Consumer ratings id, envy id. Quid sunt remarkable deserunt intricate airport cocktail classic oeso rogi grit.</p>

      <div class="article-gallery">
        <img src="${pageContext.request.contextPath}/assets/img/gallery-1.jpg" alt="Hình minh hoạ 1" />
        <img src="${pageContext.request.contextPath}/assets/img/gallery-2.jpg" alt="Hình minh hoạ 2" />
      </div>

      <p>Exquisite polaroid microfoam chicharrones impeccable latte art type of self proper parlour. Marvelous snoot open, narwhal pour-over clouded discerning. Oat wicorode style, et mastrous mock open.</p>
    </div>

    <section class="related">
      <h2 class="related-title">Related articles or posts</h2>
      <div class="grid grid-3">
        <article class="card">
          <img src="${pageContext.request.contextPath}/assets/img/related-1.jpg" alt="Bài viết liên quan 1" class="card-img" />
          <div class="card-body">
            <h3 class="card-title">Title</h3>
            <p class="card-text">Author</p>
          </div>
        </article>
        <article class="card">
          <img src="${pageContext.request.contextPath}/assets/img/related-2.jpg" alt="Bài viết liên quan 2" class="card-img" />
          <div class="card-body">
            <h3 class="card-title">Title</h3>
            <p class="card-text">Author</p>
          </div>
        </article>
        <article class="card">
          <img src="${pageContext.request.contextPath}/assets/img/related-3.jpg" alt="Bài viết liên quan 3" class="card-img" />
          <div class="card-body">
            <h3 class="card-title">Title</h3>
            <p class="card-text">Author</p>
          </div>
        </article>
      </div>
    </section>
  </main>

  <%@ include file="/includes/footer.jsp" %>

  <script src="${pageContext.request.contextPath}/assets/js/common.js"></script>
</body>
</html>
