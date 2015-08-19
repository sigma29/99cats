class SessionsController < ApplicationController
  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by(user_name: params[:user][:user_name])
    if @user && @user.is_password?(params[:user][:password])
      @user.reset_session_token!
      session[:session_token] = @user.session_token
      redirect_to cats_url
    else
      flash.now[:errors] = ["Invalid password and username combination."]
      render :new
    end
  end

  def destroy
  end
end
