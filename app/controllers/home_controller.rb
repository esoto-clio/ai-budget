class HomeController < ApplicationController
  def index
    if logged_in?
      # Redirect authenticated users to their dashboard
      redirect_to user_path(current_user)
    else
      # Show landing page for non-authenticated users
      render :index
    end
  end
end
