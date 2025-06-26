class Category < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :name, presence: true
  validates :color, presence: true, format: { with: /\A#[0-9A-F]{6}\z/i }

  scope :with_spending, ->(start_date = nil, end_date = nil) {
    joins(:transactions)
      .where(transactions: { transaction_type: "expense" })
      .where(start_date && end_date ? { transactions: { date: start_date..end_date } } : {})
      .select("categories.*, SUM(transactions.amount) as total_spent")
      .group("categories.id")
  }

  def total_spent(start_date = nil, end_date = nil)
    scope = transactions.where(transaction_type: "expense")
    scope = scope.where(date: start_date..end_date) if start_date && end_date
    scope.sum(:amount)
  end
end
