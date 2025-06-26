import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dashboard"
export default class extends Controller {
  static targets = ["financialStats", "recentTransactions", "budgetProgress"]
  static values = { 
    refreshInterval: { type: Number, default: 30000 },
    autoRefresh: { type: Boolean, default: false }
  }

  connect() {
    if (this.autoRefreshValue) {
      this.startAutoRefresh()
    }
  }

  disconnect() {
    this.stopAutoRefresh()
  }

  startAutoRefresh() {
    this.refreshTimer = setInterval(() => {
      this.refreshStats()
    }, this.refreshIntervalValue)
  }

  stopAutoRefresh() {
    if (this.refreshTimer) {
      clearInterval(this.refreshTimer)
    }
  }

  async refreshStats() {
    try {
      const response = await fetch('/api/v1/dashboard/stats', {
        headers: {
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })

      if (response.ok) {
        const data = await response.json()
        this.updateFinancialStats(data)
        this.updateRecentTransactions(data.recent_transactions)
      }
    } catch (error) {
      console.error('Failed to refresh dashboard stats:', error)
    }
  }

  updateFinancialStats(data) {
    if (this.hasFinancialStatsTarget) {
      // Update income, expenses, and net balance
      const incomeElement = this.financialStatsTarget.querySelector('[data-stat="income"]')
      const expensesElement = this.financialStatsTarget.querySelector('[data-stat="expenses"]')
      const balanceElement = this.financialStatsTarget.querySelector('[data-stat="balance"]')

      if (incomeElement) {
        incomeElement.textContent = `$${data.total_income.toFixed(2)}`
      }
      if (expensesElement) {
        expensesElement.textContent = `$${data.total_expenses.toFixed(2)}`
      }
      if (balanceElement) {
        balanceElement.textContent = `$${data.net_balance.toFixed(2)}`
        balanceElement.className = data.net_balance >= 0 ? 'text-2xl font-bold text-green-600' : 'text-2xl font-bold text-red-600'
      }
    }
  }

  updateRecentTransactions(transactions) {
    if (this.hasRecentTransactionsTarget && transactions.length > 0) {
      // Update recent transactions list
      const transactionsList = this.recentTransactionsTarget.querySelector('[data-transactions-list]')
      if (transactionsList) {
        transactionsList.innerHTML = transactions.map(transaction => 
          this.generateTransactionHTML(transaction)
        ).join('')
      }
    }
  }

  generateTransactionHTML(transaction) {
    const amountClass = transaction.transaction_type === 'income' ? 'text-green-600' : 'text-red-600'
    const amountPrefix = transaction.transaction_type === 'income' ? '+' : '-'
    
    return `
      <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
        <div class="flex items-center space-x-3">
          <div class="w-10 h-10 rounded-full flex items-center justify-center" 
               style="background-color: ${transaction.category.color}20;">
            <span class="text-xs font-medium" style="color: ${transaction.category.color};">
              ${transaction.category.name.charAt(0).toUpperCase()}
            </span>
          </div>
          <div>
            <p class="font-medium text-gray-900">${transaction.description}</p>
            <p class="text-sm text-gray-500">${transaction.category.name} • ${new Date(transaction.date).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}</p>
          </div>
        </div>
        <span class="font-semibold ${amountClass}">
          ${amountPrefix}$${Math.abs(transaction.amount).toFixed(2)}
        </span>
      </div>
    `
  }

  // Manual refresh triggered by user
  refresh() {
    this.refreshStats()
    
    // Show feedback
    const refreshButton = this.element.querySelector('[data-action="click->dashboard#refresh"]')
    if (refreshButton) {
      const originalText = refreshButton.textContent
      refreshButton.textContent = 'Refreshing...'
      refreshButton.disabled = true
      
      setTimeout(() => {
        refreshButton.textContent = originalText
        refreshButton.disabled = false
      }, 1000)
    }
  }
} 