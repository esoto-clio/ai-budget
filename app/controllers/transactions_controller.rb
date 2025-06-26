class TransactionsController < ApplicationController
  before_action :set_current_user
  before_action :set_transaction, only: [ :show, :edit, :update, :destroy ]

  def index
    @transactions = @current_user.transactions.recent.includes(:category)
    @transactions = @transactions.where(transaction_type: params[:type]) if params[:type].present?
    @transactions = @transactions.page(params[:page]).per(20) if defined?(Kaminari)

    @total_income = @current_user.transactions.income.sum(:amount)
    @total_expenses = @current_user.transactions.expenses.sum(:amount)
  end

  def show
  end

  def new
    @transaction = @current_user.transactions.build
    @categories = @current_user.categories.order(:name)
  end

  def create
    @transaction = @current_user.transactions.build(transaction_params)
    @categories = @current_user.categories.order(:name)

    if @transaction.save
      redirect_to @transaction, notice: "Transaction was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @categories = @current_user.categories.order(:name)
  end

  def update
    @categories = @current_user.categories.order(:name)

    if @transaction.update(transaction_params)
      redirect_to @transaction, notice: "Transaction was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy
    redirect_to transactions_url, notice: "Transaction was successfully deleted."
  end

  def summary
    @start_date = params[:start_date]&.to_date || Date.current.beginning_of_month
    @end_date = params[:end_date]&.to_date || Date.current.end_of_month

    @income_by_category = @current_user.transactions.income
                                      .joins(:category)
                                      .where(date: @start_date..@end_date)
                                      .group("categories.name")
                                      .sum(:amount)

    @expenses_by_category = @current_user.transactions.expenses
                                        .joins(:category)
                                        .where(date: @start_date..@end_date)
                                        .group("categories.name")
                                        .sum(:amount)
  end

  private

  def set_current_user
    @current_user = User.first_or_create!(
      name: "Demo User",
      email: "demo@budget.app"
    )
  end

  def set_transaction
    @transaction = @current_user.transactions.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:description, :amount, :transaction_type, :date, :category_id)
  end
end
