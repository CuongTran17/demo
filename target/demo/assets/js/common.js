// Common navigation and dropdown functionality
document.addEventListener('DOMContentLoaded', function() {
  // Hamburger menu toggle
  const hamburgerBtn = document.getElementById('hamburger');
  const mainMenu = document.querySelector('.menu');
  
  if (hamburgerBtn && mainMenu) {
    hamburgerBtn.addEventListener('click', function() {
      const open = hamburgerBtn.getAttribute('aria-expanded') === 'true';
      hamburgerBtn.setAttribute('aria-expanded', String(!open));
      mainMenu.classList.toggle('open');
    });
  }

  // Dropdown menu toggle
  const ddTrigger = document.querySelector('.menu .has-dd');
  const ddParent = ddTrigger ? ddTrigger.closest('.dropdown') : null;
  
  if (ddTrigger && ddParent) {
    ddTrigger.addEventListener('click', function(e) {
      e.preventDefault();
      const wasOpen = ddParent.classList.contains('open');
      
      // Close all dropdowns
      document.querySelectorAll('.dropdown.open').forEach(function(d) {
        d.classList.remove('open');
        const trigger = d.querySelector('.has-dd');
        if (trigger) trigger.setAttribute('aria-expanded', 'false');
      });
      
      // Toggle current dropdown
      if (!wasOpen) {
        ddParent.classList.add('open');
        ddTrigger.setAttribute('aria-expanded', 'true');
      } else {
        ddTrigger.setAttribute('aria-expanded', 'false');
      }
    });
    
    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
      if (!ddParent.contains(e.target)) {
        ddParent.classList.remove('open');
        ddTrigger.setAttribute('aria-expanded', 'false');
      }
    });
  }

  // Search Modal functionality
  const searchTrigger = document.getElementById('searchTrigger');
  const searchModal = document.getElementById('searchModal');
  const searchModalClose = document.getElementById('searchModalClose');
  const searchModalInput = document.getElementById('searchModalInput');

  if (searchTrigger && searchModal) {
    // Open modal
    searchTrigger.addEventListener('click', function(e) {
      e.preventDefault();
      searchModal.classList.add('active');
      // Focus on input after animation
      setTimeout(function() {
        if (searchModalInput) searchModalInput.focus();
      }, 100);
    });

    // Close modal
    if (searchModalClose) {
      searchModalClose.addEventListener('click', function() {
        searchModal.classList.remove('active');
      });
    }

    // Close on overlay click
    searchModal.addEventListener('click', function(e) {
      if (e.target === searchModal) {
        searchModal.classList.remove('active');
      }
    });

    // Close on Escape key
    document.addEventListener('keydown', function(e) {
      if (e.key === 'Escape' && searchModal.classList.contains('active')) {
        searchModal.classList.remove('active');
      }
    });
  }
});

