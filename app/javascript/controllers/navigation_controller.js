import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navigation"
export default class extends Controller {
  static targets = ["userMenu", "mobileMenu", "mobileButton"]

  connect() {
    // Store bound functions to properly remove them later
    this.boundClickOutside = this.handleClickOutside.bind(this)
    this.boundKeydown = this.handleKeydown.bind(this)
    
    // Add click outside listeners
    document.addEventListener('click', this.boundClickOutside)
    document.addEventListener('keydown', this.boundKeydown)
  }

  disconnect() {
    document.removeEventListener('click', this.boundClickOutside)
    document.removeEventListener('keydown', this.boundKeydown)
  }

  toggleUserMenu(event) {
    event.preventDefault()
    event.stopPropagation()
    
    this.userMenuTarget.classList.toggle('opacity-0')
    this.userMenuTarget.classList.toggle('invisible')
  }

  closeUserMenu() {
    if (this.hasUserMenuTarget) {
      this.userMenuTarget.classList.add('opacity-0')
      this.userMenuTarget.classList.add('invisible')
    }
  }

  toggleMobileMenu(event) {
    event.preventDefault()
    event.stopPropagation()
    
    this.mobileMenuTarget.classList.toggle('hidden')
    this.updateMobileIcon()
  }

  updateMobileIcon() {
    const icon = this.mobileButtonTarget.querySelector('svg')
    if (this.mobileMenuTarget.classList.contains('hidden')) {
      // Show hamburger icon
      icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>'
    } else {
      // Show close icon
      icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>'
    }
  }

  handleClickOutside(event) {
    // Close user menu if clicking outside - but allow clicks inside the dropdown
    if (this.hasUserMenuTarget) {
      const userMenuButton = this.element.querySelector('[data-action*="toggleUserMenu"]')
      const isClickingButton = userMenuButton && userMenuButton.contains(event.target)
      const isClickingDropdown = this.userMenuTarget.contains(event.target)
      
      if (!isClickingButton && !isClickingDropdown) {
        this.userMenuTarget.classList.add('opacity-0')
        this.userMenuTarget.classList.add('invisible')
      }
    }

    // Close mobile menu if clicking outside
    if (this.hasMobileMenuTarget && 
        !this.element.contains(event.target)) {
      this.mobileMenuTarget.classList.add('hidden')
      this.updateMobileIcon()
    }
  }

  handleKeydown(event) {
    if (event.key === 'Escape') {
      // Close user menu
      if (this.hasUserMenuTarget) {
        this.userMenuTarget.classList.add('opacity-0')
        this.userMenuTarget.classList.add('invisible')
      }

      // Close mobile menu
      if (this.hasMobileMenuTarget) {
        this.mobileMenuTarget.classList.add('hidden')
        this.updateMobileIcon()
      }
    }
  }
} 