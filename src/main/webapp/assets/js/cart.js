// Cart utility functions - shared across all course pages
const baseUrl = window.location.origin;

function addToCart(courseId, courseName, price, redirectPage) {
  fetch(baseUrl + '/cart?action=add&courseId=' + courseId, {
    method: 'POST'
  })
  .then(response => response.json())
  .then(data => {
    if (data.requireLogin) {
      // User not logged in - redirect to login
      if (confirm(data.message + '\n\nBạn có muốn đăng nhập ngay không?')) {
        const currentPage = redirectPage || window.location.pathname;
        window.location.href = baseUrl + '/login.jsp?redirect=' + encodeURIComponent(currentPage);
      }
    } else if (data.success) {
      // Success - show notification and reload
      alert('✅ ' + data.message);
      location.reload();
    } else {
      // Already in cart or other error
      alert('⚠️ ' + data.message);
    }
  })
  .catch(error => {
    console.error('Error:', error);
    alert('❌ Có lỗi xảy ra. Vui lòng thử lại!');
  });
}

// Legacy functions - kept for compatibility but not used anymore
function getCart() {
  return [];
}

function saveCart(cart) {
  // No-op - cart is now stored in database
}

// Check if course is purchased
function isCoursePurchased(courseId) {
  // Must be logged in to have purchased courses
  if (!window.isUserLoggedIn) return false;
  
  // Check from server-side purchased list
  if (window.purchasedCourses && Array.isArray(window.purchasedCourses)) {
    return window.purchasedCourses.includes(courseId);
  }
  
  return false;
}

// Fetch purchased courses from server
function fetchPurchasedCourses() {
  return fetch(window.contextPath + '/api/purchased-courses')
    .then(response => response.json())
    .then(data => {
      if (data.loggedIn && data.purchasedCourses) {
        window.purchasedCourses = data.purchasedCourses;
        return data.purchasedCourses;
      }
      window.purchasedCourses = [];
      return [];
    })
    .catch(error => {
      console.error('Error fetching purchased courses:', error);
      window.purchasedCourses = [];
      return [];
    });
}

// Update course buttons on page load
function updateCourseButtons() {
  // Only update if user is logged in
  if (!window.isUserLoggedIn) return;
  
  // Fetch purchased courses first, then update buttons
  fetchPurchasedCourses().then(() => {
    document.querySelectorAll('.btn-add-cart').forEach(function(button) {
      const onclickAttr = button.getAttribute('onclick');
      if (!onclickAttr) return;
      
      const match = onclickAttr.match(/addToCart\('([^']+)'/);
      if (!match) return;
      
      const courseId = match[1];
      if (isCoursePurchased(courseId)) {
        button.innerHTML = '<svg width="18" height="18" viewBox="0 0 24 24" fill="none"><path d="M8 5v14l11-7z" fill="currentColor"/></svg> Học ngay';
        button.className = 'btn-learn-now';
        button.setAttribute('onclick', 'learnCourse("' + courseId + '")');
      }
    });
  });
}

// Navigate to learning page
function learnCourse(courseId) {
  window.location.href = window.contextPath + '/learning.jsp?course=' + courseId;
}

// Smooth scroll to courses section
function scrollToCourses() {
  var el = document.getElementById('all-courses');
  if (!el) return;
  el.scrollIntoView({behavior: 'smooth', block: 'start'});
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
  updateCourseButtons();
});
