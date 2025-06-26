class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # CSRF protection
  protect_from_forgery with: :exception

  # Authentication helpers
  include SessionsHelper

  private

  # Require user to be logged in
  def require_login
    unless logged_in?
      store_location
      flash[:alert] = "You must be logged in to access this page."
      redirect_to login_path
    end
  end

  # Require user to be the correct user (for profile/account actions)
  def require_correct_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:alert] = "You can only access your own account."
      redirect_to root_path
    end
  end

  # Redirect logged in users away from login/signup pages
  def require_not_logged_in
    if logged_in?
      flash[:notice] = "You are already logged in."
      redirect_to dashboard_path
    end
  end

  # Secure headers for added security
  before_action :set_security_headers

  def set_security_headers
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-XSS-Protection"] = "1; mode=block"
    response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
  end
end
