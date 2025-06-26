# Base API controller for JSON API endpoints
class Api::ApplicationController < ActionController::Base
  # Skip CSRF for API endpoints (will use token authentication later)
  skip_before_action :verify_authenticity_token

  # Include authentication helpers
  include SessionsHelper

  private

  # API authentication (for now, use session-based auth)
  def require_api_login
    unless logged_in?
      render json: { error: "Authentication required" }, status: :unauthorized
    end
  end

  # Handle not found errors
  def handle_not_found
    render json: { error: "Resource not found" }, status: :not_found
  end
end
