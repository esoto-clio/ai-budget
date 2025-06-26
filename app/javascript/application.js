// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Navigation functionality
document.addEventListener('DOMContentLoaded', function() {
  // Handle user menu dropdown
  const userMenuButton = document.querySelector('[data-user-menu-button]');
  const userMenuDropdown = document.querySelector('[data-user-menu-dropdown]');
  
  if (userMenuButton && userMenuDropdown) {
    // Toggle dropdown on button click
    userMenuButton.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      userMenuDropdown.classList.toggle('opacity-0');
      userMenuDropdown.classList.toggle('invisible');
    });
    
    // Close dropdown when clicking outside
    document.addEventListener('click', function(e) {
      if (!userMenuButton.contains(e.target) && !userMenuDropdown.contains(e.target)) {
        userMenuDropdown.classList.add('opacity-0');
        userMenuDropdown.classList.add('invisible');
      }
    });
    
    // Close dropdown when pressing escape
    document.addEventListener('keydown', function(e) {
      if (e.key === 'Escape') {
        userMenuDropdown.classList.add('opacity-0');
        userMenuDropdown.classList.add('invisible');
      }
    });
  }
  
  // Handle mobile menu
  const mobileMenuButton = document.querySelector('[data-mobile-menu-button]');
  const mobileMenu = document.querySelector('[data-mobile-menu]');
  
  if (mobileMenuButton && mobileMenu) {
    // Toggle mobile menu on button click
    mobileMenuButton.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      mobileMenu.classList.toggle('hidden');
      
      // Update button icon
      const icon = mobileMenuButton.querySelector('svg');
      if (mobileMenu.classList.contains('hidden')) {
        // Show hamburger icon
        icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>';
      } else {
        // Show close icon
        icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>';
      }
    });
    
    // Close mobile menu when clicking outside
    document.addEventListener('click', function(e) {
      if (!mobileMenuButton.contains(e.target) && !mobileMenu.contains(e.target)) {
        mobileMenu.classList.add('hidden');
        // Reset button icon
        const icon = mobileMenuButton.querySelector('svg');
        icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>';
      }
    });
    
    // Close mobile menu when pressing escape
    document.addEventListener('keydown', function(e) {
      if (e.key === 'Escape') {
        mobileMenu.classList.add('hidden');
        // Reset button icon
        const icon = mobileMenuButton.querySelector('svg');
        icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>';
      }
    });
  }
});

// Handle flash message dismissal
document.addEventListener('DOMContentLoaded', function() {
  const flashMessages = document.querySelectorAll('[data-flash-message]');
  
  flashMessages.forEach(function(message) {
    // Auto-dismiss success messages after 5 seconds
    if (message.classList.contains('bg-green-50')) {
      setTimeout(function() {
        message.style.transition = 'opacity 0.5s ease-out';
        message.style.opacity = '0';
        setTimeout(function() {
          message.remove();
        }, 500);
      }, 5000);
    }
  });
});
