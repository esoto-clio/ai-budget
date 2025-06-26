class UsersController < ApplicationController
  before_action :require_not_logged_in, only: [ :new, :create ]
  before_action :require_login, only: [ :show, :edit, :update ]
  before_action :require_correct_user, only: [ :show, :edit, :update ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in(@user)
      flash[:notice] = "Welcome to Budget Tracker, #{@user.name}! Your account has been created successfully."
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @user is set by require_correct_user
  end

  def edit
    # @user is set by require_correct_user
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "Your profile has been updated successfully."
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
