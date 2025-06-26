import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  static values = { 
    autoDismiss: Boolean,
    delay: { type: Number, default: 5000 }
  }

  connect() {
    if (this.autoDismissValue) {
      this.scheduleAutoDismiss()
    }
  }

  dismiss() {
    this.element.style.transition = 'opacity 0.5s ease-out, transform 0.5s ease-out'
    this.element.style.opacity = '0'
    this.element.style.transform = 'translateY(-10px)'
    
    setTimeout(() => {
      this.element.remove()
    }, 500)
  }

  scheduleAutoDismiss() {
    setTimeout(() => {
      this.dismiss()
    }, this.delayValue)
  }
} 