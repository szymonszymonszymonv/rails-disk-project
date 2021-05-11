class PublicController < ApplicationController

  def home
    if session[:user_id]
      @user = User.find_by(id: session[:user_id])
      'navbar_logged_in'
    else
      'navbar'
    end
  end
  helper_method :home

end
