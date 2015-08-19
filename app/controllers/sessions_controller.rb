class SessionsController < ApplicationController

  before_action :already_logged_in?, only: [:create,:new]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by(user_name: params[:user][:user_name])
    if @user && @user.is_password?(params[:user][:password])
      login_user!(@user)
      redirect_to cats_url
    else
      flash.now[:errors] = ["Invalid password and username combination."]
      render :new
    end
  end

  def destroy
    logout_user!
    redirect_to new_session_url
  end
end
