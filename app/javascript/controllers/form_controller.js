import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="form"
export default class extends Controller {
  static targets = ["submit", "status"]
  static values = { 
    autoSave: Boolean,
    autoSaveDelay: { type: Number, default: 2000 },
    validateOnChange: Boolean
  }

  connect() {
    if (this.autoSaveValue) {
      this.setupAutoSave()
    }
    
    if (this.validateOnChangeValue) {
      this.setupValidation()
    }
    
    this.setupSubmitHandler()
  }

  disconnect() {
    this.clearAutoSaveTimer()
  }

  setupAutoSave() {
    // Listen for input changes
    this.element.addEventListener('input', this.scheduleAutoSave.bind(this))
    this.element.addEventListener('change', this.scheduleAutoSave.bind(this))
  }

  setupValidation() {
    // Real-time validation
    this.element.addEventListener('input', this.validateField.bind(this))
    this.element.addEventListener('blur', this.validateField.bind(this))
  }

  setupSubmitHandler() {
    this.element.addEventListener('submit', this.handleSubmit.bind(this))
  }

  scheduleAutoSave() {
    this.clearAutoSaveTimer()
    this.showStatus('Typing...', 'text-gray-500')
    
    this.autoSaveTimer = setTimeout(() => {
      this.autoSave()
    }, this.autoSaveDelayValue)
  }

  clearAutoSaveTimer() {
    if (this.autoSaveTimer) {
      clearTimeout(this.autoSaveTimer)
    }
  }

  async autoSave() {
    const formData = new FormData(this.element)
    
    // Add auto-save indicator
    formData.append('auto_save', 'true')
    
    this.showStatus('Saving...', 'text-blue-500')
    
    try {
      const response = await fetch(this.element.action, {
        method: 'PATCH',
        body: formData,
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
      })

      if (response.ok) {
        this.showStatus('Saved', 'text-green-500')
        setTimeout(() => this.hideStatus(), 2000)
      } else {
        this.showStatus('Save failed', 'text-red-500')
      }
    } catch (error) {
      this.showStatus('Save failed', 'text-red-500')
      console.error('Auto-save error:', error)
    }
  }

  validateField(event) {
    const field = event.target
    
    // Remove existing validation classes
    field.classList.remove('border-red-300', 'border-green-300')
    
    // Basic validation
    if (field.hasAttribute('required') && !field.value.trim()) {
      this.showFieldError(field, 'This field is required')
    } else if (field.type === 'email' && field.value && !this.isValidEmail(field.value)) {
      this.showFieldError(field, 'Please enter a valid email')
    } else if (field.type === 'number' && field.value && isNaN(field.value)) {
      this.showFieldError(field, 'Please enter a valid number')
    } else {
      this.showFieldSuccess(field)
    }
  }

  showFieldError(field, message) {
    field.classList.add('border-red-300')
    
    // Show error message
    let errorElement = field.parentNode.querySelector('.field-error')
    if (!errorElement) {
      errorElement = document.createElement('p')
      errorElement.className = 'field-error text-sm text-red-600 mt-1'
      field.parentNode.appendChild(errorElement)
    }
    errorElement.textContent = message
  }

  showFieldSuccess(field) {
    field.classList.add('border-green-300')
    
    // Remove error message
    const errorElement = field.parentNode.querySelector('.field-error')
    if (errorElement) {
      errorElement.remove()
    }
  }

  handleSubmit(event) {
    if (this.hasSubmitTarget) {
      this.submitTarget.disabled = true
      this.submitTarget.textContent = 'Submitting...'
    }
  }

  showStatus(message, className) {
    if (this.hasStatusTarget) {
      this.statusTarget.textContent = message
      this.statusTarget.className = `text-sm ${className}`
      this.statusTarget.style.display = 'block'
    }
  }

  hideStatus() {
    if (this.hasStatusTarget) {
      this.statusTarget.style.display = 'none'
    }
  }

  isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email)
  }

  // Reset form state after successful submission
  reset() {
    this.element.reset()
    if (this.hasSubmitTarget) {
      this.submitTarget.disabled = false
      this.submitTarget.textContent = this.submitTarget.dataset.originalText || 'Submit'
    }
    this.hideStatus()
  }
} 