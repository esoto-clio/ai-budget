class User < ApplicationRecord
  has_many :categories, dependent: :destroy
  has_many :budget_plans, dependent: :destroy
  has_many :transactions, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def total_income(start_date = nil, end_date = nil)
    scope = transactions.where(transaction_type: "income")
    scope = scope.where(date: start_date..end_date) if start_date && end_date
    scope.sum(:amount)
  end

  def total_expenses(start_date = nil, end_date = nil)
    scope = transactions.where(transaction_type: "expense")
    scope = scope.where(date: start_date..end_date) if start_date && end_date
    scope.sum(:amount)
  end

  def net_balance(start_date = nil, end_date = nil)
    total_income(start_date, end_date) - total_expenses(start_date, end_date)
  end
end
