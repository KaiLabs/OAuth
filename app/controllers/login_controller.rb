class LoginController < ApplicationController
  
  # before_filter :save_login_state, :only => [:index]
  
  # A function to authorize user to login

  def index
   # render welcome_index_path
  end
  
  # def login
  #   authorized_user = User.authenticate(params[:email_or_username],params[:login_password])
  #   if authorized_user
  #     flash[:notice] = "You are now logged in as #{authorized_user.username}"
  #     session[:user_id] = authorized_user.id
  #     redirect_to programs_path
  #   else
  #     flash[:error] = "Invalid Username or Password"
  #    # flash[:notice] = "You have successfully logged out"
  #    # flash.discard(:error)
  #     redirect_to welcome_index_path
  #   end
  # end
end
