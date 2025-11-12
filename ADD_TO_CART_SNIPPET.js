// JavaScript functions for add-to-cart functionality
// Copy this to all courses-*.jsp files before </script> tag

// Add to cart function with AJAX
function addToCart(courseId, courseName, price) {
  fetch('${pageContext.request.contextPath}/cart', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: 'action=add&courseId=' + courseId
  })
  .then(response => response.json())
  .then(data => {
    if (data.success) {
      showNotification('✅ Đã thêm "' + courseName + '" vào giỏ hàng!', 'success');
    } else {
      showNotification('ℹ️ Khóa học đã có trong giỏ hàng', 'info');
    }
  })
  .catch(error => {
    console.error('Error:', error);
    showNotification('❌ Có lỗi xảy ra, vui lòng thử lại', 'error');
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

// CSS animations - add before </body>
<style>
  @keyframes slideIn {
    from { transform: translateX(400px); opacity: 0; }
    to { transform: translateX(0); opacity: 1; }
  }
  @keyframes slideOut {
    from { transform: translateX(0); opacity: 1; }
    to { transform: translateX(400px); opacity: 0; }
  }
</style>
