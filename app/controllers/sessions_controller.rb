class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def new
    @user = session[:user]
    if @user
      render json: {
        user: @user,
        directories: @user.directories,
        status: :ok,
        message: 'Success'
      }
    else
      render json: { message: 'error', status: :not_found }
    end
  end

  def create
    @user = User.find_by(email: params[:email])
    puts 'USER HERE >> %s' % [@user.email]
    puts 'PARAMS HERE >> %s' % [params]
    pass_test = params[:password]
    if @user.present? && @user.password == pass_test
      puts 'LOGGED IN SUCCESSFULLY'
      session[:user_id] = @user.id
      puts 'SESSION USER ID >>>>>>' % [session[:user_id]]
      render json: { 
        status: :ok, 
        message: 'Success',
        user: @user.email,
        directories: @user.directories.where(parent_id: nil)
       }
      # redirect_to root_path, notice: "LOGIN SUCCESSFUL"
    else
      render json: { message: 'INVALID LOGIN OR PASSWORD', status: :not_found }
      puts 'LOGGING IN UNSUCCESSFULL'
      # flash.alert = "INVALID LOGIN OR PASSWORD"
      # render :new
    end
  end

  def get_root
    @user = User.find_by(email: params[:email])
    puts params
    render json: { 
      status: :ok, 
      message: 'Success',
      directories: @user.directories.where(parent_id: nil)
     }
  end

  def destroy
    session.clear 
    render json: { message: 'user logged out / session cleared', status: :ok }
    # redirect_to root_path, notice: "LOGGED OUT"
  end

end
