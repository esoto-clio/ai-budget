class Api::V1::CategoriesController < Api::ApplicationController
  before_action :require_api_login

  def index
    @categories = current_user.categories.order(:name)

    render json: {
      categories: @categories.map do |category|
        {
          id: category.id,
          name: category.name,
          color: category.color,
          transaction_count: category.transactions.count,
          total_spent: category.total_spent(Date.current.beginning_of_month, Date.current.end_of_month),
        }
      end,
    }
  end
end
