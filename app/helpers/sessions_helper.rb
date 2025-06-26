module SessionsHelper
  # Log in the given user
  def log_in(user)
    session[:user_id] = user.id
    # Regenerate session ID to prevent session fixation
    session.delete(:user_id)
    reset_session
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any)
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue ActiveRecord::RecordNotFound
    session.delete(:user_id)
    nil
  end

  # Returns true if the user is logged in, false otherwise
  def logged_in?
    !current_user.nil?
  end

  # Returns true if the given user is the current user
  def current_user?(user)
    user && user == current_user
  end

  # Logs out the current user
  def log_out
    reset_session
    @current_user = nil
  end

  # Store requested URL for post-login redirect
  def store_location
    session[:forwarding_url] = request.original_url if request.get? || request.head?
  end

  # Redirect to stored location or default
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default, allow_other_host: false)
    session.delete(:forwarding_url)
  end
end
