import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search"
export default class extends Controller {
  static targets = ["input", "results", "loading"]
  static values = { 
    url: String,
    debounce: { type: Number, default: 300 },
    minLength: { type: Number, default: 2 }
  }

  connect() {
    this.setupSearch()
  }

  disconnect() {
    this.clearDebounceTimer()
  }

  setupSearch() {
    if (this.hasInputTarget) {
      this.inputTarget.addEventListener('input', this.handleInput.bind(this))
      this.inputTarget.addEventListener('focus', this.handleFocus.bind(this))
      this.inputTarget.addEventListener('blur', this.handleBlur.bind(this))
    }
  }

  handleInput() {
    this.clearDebounceTimer()
    
    const query = this.inputTarget.value.trim()
    
    if (query.length >= this.minLengthValue) {
      this.showLoading()
      this.debounceTimer = setTimeout(() => {
        this.performSearch(query)
      }, this.debounceValue)
    } else {
      this.clearResults()
    }
  }

  handleFocus() {
    if (this.hasResultsTarget && this.resultsTarget.children.length > 0) {
      this.showResults()
    }
  }

  handleBlur() {
    // Delay hiding results to allow for clicking
    setTimeout(() => {
      this.hideResults()
    }, 200)
  }

  async performSearch(query) {
    try {
      const url = new URL(this.urlValue, window.location.origin)
      url.searchParams.set('q', query)
      
      const response = await fetch(url, {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })

      if (response.ok) {
        const data = await response.json()
        this.displayResults(data)
      } else {
        this.showError('Search failed')
      }
    } catch (error) {
      this.showError('Search failed')
      console.error('Search error:', error)
    } finally {
      this.hideLoading()
    }
  }

  displayResults(data) {
    if (this.hasResultsTarget) {
      if (data.length === 0) {
        this.resultsTarget.innerHTML = `
          <div class="p-3 text-center text-gray-500">
            No results found
          </div>
        `
      } else {
        this.resultsTarget.innerHTML = data.map(item => 
          this.generateResultHTML(item)
        ).join('')
      }
      
      this.showResults()
    }
  }

  generateResultHTML(item) {
    // Override this method in specific implementations
    return `
      <div class="p-3 hover:bg-gray-50 cursor-pointer border-b border-gray-100 last:border-b-0">
        <p class="font-medium">${item.name || item.title}</p>
        ${item.description ? `<p class="text-sm text-gray-500">${item.description}</p>` : ''}
      </div>
    `
  }

  showLoading() {
    if (this.hasLoadingTarget) {
      this.loadingTarget.style.display = 'block'
    }
  }

  hideLoading() {
    if (this.hasLoadingTarget) {
      this.loadingTarget.style.display = 'none'
    }
  }

  showResults() {
    if (this.hasResultsTarget) {
      this.resultsTarget.style.display = 'block'
    }
  }

  hideResults() {
    if (this.hasResultsTarget) {
      this.resultsTarget.style.display = 'none'
    }
  }

  clearResults() {
    if (this.hasResultsTarget) {
      this.resultsTarget.innerHTML = ''
      this.hideResults()
    }
  }

  showError(message) {
    if (this.hasResultsTarget) {
      this.resultsTarget.innerHTML = `
        <div class="p-3 text-center text-red-500">
          ${message}
        </div>
      `
      this.showResults()
    }
  }

  clearDebounceTimer() {
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer)
    }
  }

  // Handle result selection
  selectResult(event) {
    const resultElement = event.currentTarget
    const value = resultElement.dataset.value
    const text = resultElement.dataset.text || resultElement.textContent.trim()
    
    this.inputTarget.value = text
    this.inputTarget.dataset.selectedValue = value
    
    this.hideResults()
    
    // Dispatch custom event
    this.inputTarget.dispatchEvent(new CustomEvent('search:selected', {
      detail: { value, text }
    }))
  }
} 