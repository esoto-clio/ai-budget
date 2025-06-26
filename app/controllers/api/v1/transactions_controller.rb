class Api::V1::TransactionsController < Api::ApplicationController
  before_action :require_api_login

  def index
    @transactions = current_user.transactions.recent.includes(:category)
    @transactions = @transactions.where(transaction_type: params[:type]) if params[:type].present?
    @transactions = @transactions.limit(params[:limit].to_i) if params[:limit].present?

    render json: {
      transactions: @transactions.map do |transaction|
        {
          id: transaction.id,
          description: transaction.description,
          amount: transaction.amount,
          transaction_type: transaction.transaction_type,
          date: transaction.date,
          category: {
            id: transaction.category.id,
            name: transaction.category.name,
            color: transaction.category.color,
          },
        }
      end,
    }
  end

  def show
    @transaction = current_user.transactions.find(params[:id])

    render json: {
      id: @transaction.id,
      description: @transaction.description,
      amount: @transaction.amount,
      transaction_type: @transaction.transaction_type,
      date: @transaction.date,
      category: {
        id: @transaction.category.id,
        name: @transaction.category.name,
        color: @transaction.category.color,
      },
    }
  rescue ActiveRecord::RecordNotFound
    handle_not_found
  end
end
