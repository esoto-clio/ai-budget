class Api::V1::DashboardController < Api::ApplicationController
  before_action :require_api_login

  def index
    stats = {
      total_income: current_user.transactions.income.sum(:amount),
      total_expenses: current_user.transactions.expense.sum(:amount),
      recent_transactions: recent_transactions_data,
    }

    stats[:net_balance] = stats[:total_income] - stats[:total_expenses]

    render json: stats
  end

  def stats
    stats = {
      total_income: current_user.transactions.income.sum(:amount),
      total_expenses: current_user.transactions.expense.sum(:amount),
      recent_transactions: recent_transactions_data,
    }

    stats[:net_balance] = stats[:total_income] - stats[:total_expenses]

    render json: stats
  end

  private

  def recent_transactions_data
    current_user.transactions
                .includes(:category)
                .order(created_at: :desc)
                .limit(5)
                .map do |transaction|
      {
        id: transaction.id,
        description: transaction.description,
        amount: transaction.amount,
        date: transaction.date,
        transaction_type: transaction.transaction_type,
        category: {
          id: transaction.category.id,
          name: transaction.category.name,
          color: transaction.category.color,
        },
      }
    end
  end
end
