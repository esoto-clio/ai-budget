class Api::V1::DashboardController < Api::ApplicationController
  before_action :require_api_login

  def stats
    start_date = Date.current.beginning_of_month
    end_date = Date.current.end_of_month

    total_income = current_user.total_income(start_date, end_date)
    total_expenses = current_user.total_expenses(start_date, end_date)

    render json: {
      total_income: total_income,
      total_expenses: total_expenses,
      net_balance: total_income - total_expenses,
      transaction_count: current_user.transactions.where(date: start_date..end_date).count,
      categories_count: current_user.categories.count,
      recent_transactions: current_user.transactions.recent.limit(5).includes(:category).map do |transaction|
        {
          id: transaction.id,
          description: transaction.description,
          amount: transaction.amount,
          transaction_type: transaction.transaction_type,
          date: transaction.date,
          category: {
            name: transaction.category.name,
            color: transaction.category.color
          }
        }
      end
    }
  end
end
