class CategoriesController < ApplicationController
  before_action :set_current_user
  before_action :set_category, only: [ :show, :edit, :update, :destroy ]

  def index
    @categories = @current_user.categories.order(:name)
    @categories_with_spending = @current_user.categories.with_spending(
      Date.current.beginning_of_month,
      Date.current.end_of_month
    )
  end

  def show
    @transactions = @category.transactions.recent.limit(10)
    @total_spent = @category.total_spent(Date.current.beginning_of_month, Date.current.end_of_month)
  end

  def new
    @category = @current_user.categories.build
    @category.color = generate_random_color
  end

  def create
    @category = @current_user.categories.build(category_params)

    if @category.save
      redirect_to @category, notice: "Category was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to @category, notice: "Category was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_url, notice: "Category was successfully deleted."
  end

  private

  def set_current_user
    @current_user = User.first_or_create!(
      name: "Demo User",
      email: "demo@budget.app"
    )
  end

  def set_category
    @category = @current_user.categories.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :color)
  end

  def generate_random_color
    colors = [ "#EF4444", "#F97316", "#F59E0B", "#10B981", "#3B82F6", "#6366F1", "#8B5CF6", "#EC4899" ]
    colors.sample
  end
end
