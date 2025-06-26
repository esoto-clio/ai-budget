class BudgetPlan < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :period_start, presence: true
  validates :period_end, presence: true
  validate :end_date_after_start_date

  scope :current, -> { where("period_start <= ? AND period_end >= ?", Date.current, Date.current) }
  scope :active, -> { where("period_end >= ?", Date.current) }

  def current?
    period_start <= Date.current && period_end >= Date.current
  end

  def total_spent
    user.transactions
        .where(transaction_type: "expense", date: period_start..period_end)
        .sum(:amount)
  end

  def remaining_budget
    amount - total_spent
  end

  def progress_percentage
    return 0 if amount.zero?
    ((total_spent / amount) * 100).round(2)
  end

  def days_remaining
    return 0 if period_end < Date.current
    (period_end - Date.current).to_i
  end

  private

  def end_date_after_start_date
    return unless period_start && period_end

    errors.add(:period_end, "must be after start date") if period_end <= period_start
  end
end
