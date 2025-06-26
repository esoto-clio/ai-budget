class DashboardController < ApplicationController
  before_action :require_login
  before_action :set_date_range

  def index
    @total_income = current_user.total_income(@start_date, @end_date)
    @total_expenses = current_user.total_expenses(@start_date, @end_date)
    @net_balance = @total_income - @total_expenses

    @current_budget = current_user.budget_plans.current.first
    @recent_transactions = current_user.transactions.recent.limit(5).includes(:category)
    @categories_with_spending = current_user.categories.with_spending(@start_date, @end_date)

    @monthly_summary = monthly_summary
    @expense_by_category = expense_by_category_data
  end

  private

  def set_date_range
    @start_date = Date.current.beginning_of_month
    @end_date = Date.current.end_of_month
  end

  def monthly_summary
    (1..6).map do |months_ago|
      date = months_ago.months.ago
      start_date = date.beginning_of_month
      end_date = date.end_of_month

      {
        month: date.strftime("%b"),
        income: current_user.total_income(start_date, end_date),
        expenses: current_user.total_expenses(start_date, end_date)
      }
    end.reverse
  end

  def expense_by_category_data
    current_user.categories.joins(:transactions)
                 .where(transactions: { transaction_type: "expense", date: @start_date..@end_date })
                 .group("categories.name", "categories.color")
                 .sum("transactions.amount")
                 .map { |key, value| { name: key[0], color: key[1], amount: value } }
  end
end
