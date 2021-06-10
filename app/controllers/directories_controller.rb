class DirectoriesController < ApplicationController


    def create
        puts directory_params
        user = User.find_by(id: session[:user_id])

        @directory = user.directories.build(directory_params)
        if !@directory.save
            flash.alert = "ERROR"
        end
        
            redirect_to root_path
    end

    def new
        @directory = Directory.new
      end

    def show
        @directory_parent = Directory.find(params[:id])
      end

    def directory_params
        params.require(:directory).permit(:name, :parent_id)
    end

    
    
end
