import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["container", "backdrop", "content"]
  static classes = ["open", "closing"]

  connect() {
    // Prevent body scroll when modal is open
    document.body.style.overflow = 'hidden'
    
    // Add backdrop click listener
    if (this.hasBackdropTarget) {
      this.backdropTarget.addEventListener('click', this.handleBackdropClick.bind(this))
    }
    
    // Add escape key listener
    document.addEventListener('keydown', this.handleKeydown.bind(this))
    
    // Animate in
    this.element.classList.add(...this.openClasses)
  }

  disconnect() {
    // Restore body scroll
    document.body.style.overflow = ''
    
    // Remove listeners
    document.removeEventListener('keydown', this.handleKeydown.bind(this))
  }

  close() {
    // Add closing animation
    this.element.classList.add(...this.closingClasses)
    
    // Remove modal after animation
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }

  handleBackdropClick(event) {
    if (event.target === this.backdropTarget) {
      this.close()
    }
  }

  handleKeydown(event) {
    if (event.key === 'Escape') {
      this.close()
    }
  }

  // Handle successful form submission
  success() {
    // Show success animation then close
    this.showSuccess()
    setTimeout(() => {
      this.close()
    }, 1500)
  }

  showSuccess() {
    const successIcon = `
      <div class="flex items-center justify-center w-16 h-16 mx-auto mb-4 bg-green-100 rounded-full">
        <svg class="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
        </svg>
      </div>
      <p class="text-center text-green-600 font-medium">Success!</p>
    `
    
    if (this.hasContentTarget) {
      this.contentTarget.innerHTML = successIcon
    }
  }
} 