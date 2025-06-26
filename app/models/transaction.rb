class Transaction < ApplicationRecord
  belongs_to :category
  belongs_to :user

  validates :description, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true, inclusion: { in: %w[income expense] }
  validates :date, presence: true

  scope :income, -> { where(transaction_type: "income") }
  scope :expenses, -> { where(transaction_type: "expense") }
  scope :recent, -> { order(date: :desc, created_at: :desc) }
  scope :this_month, -> { where(date: Date.current.beginning_of_month..Date.current.end_of_month) }
  scope :by_date_range, ->(start_date, end_date) { where(date: start_date..end_date) }

  def income?
    transaction_type == "income"
  end

  def expense?
    transaction_type == "expense"
  end

  def formatted_amount
    income? ? "+$#{amount}" : "-$#{amount}"
  end

  def amount_color_class
    income? ? "text-green-600" : "text-red-600"
  end
end
