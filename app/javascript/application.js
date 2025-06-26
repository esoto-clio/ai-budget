// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Turbo configuration for better UX
document.addEventListener('turbo:before-fetch-request', (event) => {
  // Add loading indicator
  const loadingIndicator = document.createElement('div')
  loadingIndicator.id = 'turbo-loading'
  loadingIndicator.className = 'fixed top-0 left-0 w-full h-1 bg-blue-600 z-50 transition-all duration-300'
  loadingIndicator.style.transform = 'scaleX(0)'
  loadingIndicator.style.transformOrigin = 'left'
  document.body.appendChild(loadingIndicator)
  
  // Animate loading bar
  setTimeout(() => {
    loadingIndicator.style.transform = 'scaleX(0.7)'
  }, 50)
})

document.addEventListener('turbo:before-fetch-response', (event) => {
  const loadingIndicator = document.getElementById('turbo-loading')
  if (loadingIndicator) {
    loadingIndicator.style.transform = 'scaleX(1)'
  }
})

document.addEventListener('turbo:load', (event) => {
  // Remove loading indicator
  const loadingIndicator = document.getElementById('turbo-loading')
  if (loadingIndicator) {
    setTimeout(() => {
      loadingIndicator.remove()
    }, 200)
  }
})

// Turbo Stream error handling
document.addEventListener('turbo:fetch-request-error', (event) => {
  console.error('Turbo fetch error:', event.detail)
  
  // Show user-friendly error message
  const errorMessage = document.createElement('div')
  errorMessage.className = 'fixed top-4 right-4 bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded-md z-50'
  errorMessage.innerHTML = `
    <div class="flex items-center space-x-2">
      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16c-.77.833.192 2.5 1.732 2.5z"></path>
      </svg>
      <span>Something went wrong. Please try again.</span>
    </div>
  `
  document.body.appendChild(errorMessage)
  
  // Auto-remove error after 5 seconds
  setTimeout(() => {
    errorMessage.remove()
  }, 5000)
})

// Global keyboard shortcuts
document.addEventListener('keydown', (event) => {
  // Cmd/Ctrl + K for quick search
  if ((event.metaKey || event.ctrlKey) && event.key === 'k') {
    event.preventDefault()
    const searchInput = document.querySelector('[data-search-target="input"]')
    if (searchInput) {
      searchInput.focus()
    }
  }
  
  // Cmd/Ctrl + N for new transaction
  if ((event.metaKey || event.ctrlKey) && event.key === 'n') {
    event.preventDefault()
    const newTransactionLink = document.querySelector('a[href*="transactions/new"]')
    if (newTransactionLink) {
      newTransactionLink.click()
    }
  }
})

// Enhanced form submission feedback
document.addEventListener('turbo:submit-start', (event) => {
  const form = event.target
  const submitButton = form.querySelector('input[type="submit"], button[type="submit"]')
  
  if (submitButton) {
    submitButton.dataset.originalText = submitButton.textContent
    submitButton.textContent = 'Submitting...'
    submitButton.disabled = true
    
    // Add loading spinner
    const spinner = document.createElement('svg')
    spinner.className = 'animate-spin -ml-1 mr-3 h-5 w-5 text-white inline'
    spinner.innerHTML = `
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" fill="none"></circle>
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
    `
    submitButton.prepend(spinner)
  }
})

document.addEventListener('turbo:submit-end', (event) => {
  const form = event.target
  const submitButton = form.querySelector('input[type="submit"], button[type="submit"]')
  
  if (submitButton) {
    const spinner = submitButton.querySelector('svg')
    if (spinner) {
      spinner.remove()
    }
    
    submitButton.textContent = submitButton.dataset.originalText || 'Submit'
    submitButton.disabled = false
  }
})

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
