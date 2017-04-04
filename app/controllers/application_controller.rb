class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authenticate_user
    if session[:user_id] == nil
      redirect_to(:controller => 'login', :action => 'index')
      return false
    else
      return true	
    end
  end

  def save_login_state
    if session[:user_id]
      flash[:error] = "You must logout to leave!"
      redirect_to(:controller => 'posts', :action => 'index')
      return false
    else
      return true
    end
  end
end
