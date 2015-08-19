class ApplicationController < ActionController::Base
  helper_method :current_user, :is_logged_in?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def current_user
    return nil unless session[:session_token]
    User.find_by(session_token: session[:session_token])
  end

  def login_user!(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
  end

  def logout_user!
    current_user.try(:reset_session_token!)

    session[:session_token] = nil
  end

  def is_logged_in?
    !!current_user
  end

  def already_logged_in?
    redirect_to cats_url if is_logged_in?
  end

  def require_log_in
    redirect_to new_session_url unless is_logged_in?
  end

end
