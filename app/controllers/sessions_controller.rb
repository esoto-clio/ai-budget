class SessionsController < ApplicationController
  before_action :require_not_logged_in, only: [ :new, :create ]

  # Rate limiting to prevent brute force attacks
  before_action :check_login_attempts, only: [ :create ]

  def new
    # Login form
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      # Reset failed login attempts on successful login
      reset_login_attempts

      # Regenerate session token to prevent session fixation
      log_in(user)

      flash[:notice] = "Welcome back, #{user.name}!"
      redirect_back_or(root_path)
    else
      # Track failed login attempts
      track_failed_login_attempt

      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    flash[:notice] = "You have been logged out successfully."
    redirect_to root_path, status: :see_other
  end

  private

  def check_login_attempts
    if session[:failed_login_attempts].to_i >= 5
      if session[:last_failed_attempt] && session[:last_failed_attempt] > 15.minutes.ago
        flash[:alert] = "Too many failed login attempts. Please try again in 15 minutes."
        redirect_to login_path and return
      else
        # Reset after cooldown period
        reset_login_attempts
      end
    end
  end

  def track_failed_login_attempt
    session[:failed_login_attempts] = session[:failed_login_attempts].to_i + 1
    session[:last_failed_attempt] = Time.current
  end

  def reset_login_attempts
    session.delete(:failed_login_attempts)
    session.delete(:last_failed_attempt)
  end
end
