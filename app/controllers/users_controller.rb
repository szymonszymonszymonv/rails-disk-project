class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    @user = User.new
  end

  def create
    puts user_params
    @user = User.new(user_params)
    puts @user
    if @user.save
      session[:user_id] = @user.id
      render json: { 
        status: :ok, 
        message: 'Success',
        user: @user.email,
        directories: @user.directories
       }
      # redirect_to root_path, notice: "ACCOUNT CREATED SUCCESSFULLY!"
    else
      render json: { message: 'error', status: :not_found }
      # render :new
    end
  
  end

  def show
    @users = User.all
    render json: @users
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
