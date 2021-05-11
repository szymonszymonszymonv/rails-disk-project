class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:email])
    pass_test = params[:password]
    if user.present? && user.password == pass_test
      session[:user_id] = user.id
      redirect_to root_path, notice: "LOGIN SUCCESSFUL"
    else
      flash.alert = "INVALID LOGIN OR PASSWORD"
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to root_path, notice: "LOGGED OUT"
  end
end
