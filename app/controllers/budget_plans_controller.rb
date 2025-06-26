class BudgetPlansController < ApplicationController
  before_action :set_current_user
  before_action :set_budget_plan, only: [ :show, :edit, :update, :destroy ]

  def index
    @budget_plans = @current_user.budget_plans.order(period_start: :desc)
    @current_budget = @current_user.budget_plans.current.first
    @active_budgets = @current_user.budget_plans.active.order(period_start: :desc)
  end

  def show
    @transactions = @current_user.transactions.expenses
                                 .where(date: @budget_plan.period_start..@budget_plan.period_end)
                                 .recent
                                 .includes(:category)

    @spending_by_category = @current_user.transactions.expenses
                                        .joins(:category)
                                        .where(date: @budget_plan.period_start..@budget_plan.period_end)
                                        .group("categories.name", "categories.color")
                                        .sum(:amount)
                                        .map { |key, value| { name: key[0], color: key[1], amount: value } }
  end

  def new
    @budget_plan = @current_user.budget_plans.build
    @budget_plan.period_start = Date.current.beginning_of_month
    @budget_plan.period_end = Date.current.end_of_month
  end

  def create
    @budget_plan = @current_user.budget_plans.build(budget_plan_params)

    if @budget_plan.save
      redirect_to @budget_plan, notice: "Budget plan was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @budget_plan.update(budget_plan_params)
      redirect_to @budget_plan, notice: "Budget plan was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @budget_plan.destroy
    redirect_to budget_plans_url, notice: "Budget plan was successfully deleted."
  end

  private

  def set_current_user
    @current_user = User.first_or_create!(
      name: "Demo User",
      email: "demo@budget.app"
    )
  end

  def set_budget_plan
    @budget_plan = @current_user.budget_plans.find(params[:id])
  end

  def budget_plan_params
    params.require(:budget_plan).permit(:name, :amount, :period_start, :period_end)
  end
end
