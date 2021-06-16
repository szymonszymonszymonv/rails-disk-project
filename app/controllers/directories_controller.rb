class DirectoriesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def create
        puts directory_params
        puts "USER >>>>>>>>>>>>> " % [params[:user]]
        @user = User.find_by(email: params[:user])
        @directory = @user.directories.build(directory_params)
        if !@directory.save
            render json: { message: "COULDN'T CREATE DIRECTORY", status: :not_found }
            puts "COULDN'T CREATE DIRECTORY"
        else
            render json: { 
                status: :ok, 
                message: 'Success',
                user: @user.email,
                directory: @directory
               }
            puts "SUCCESSFULLY CREATED DIRECTORY"
        end
            # redirect_to root_path
    end

    def new
        @directory = Directory.new
    end

    def show
        @directory_parent = Directory.find(params[:id])
    end

    def show_children
        @directory = Directory.find(params[:id])
        if !@directory
            render json: { message: "COULDN'T GET CHILDREN", status: :not_found }
            puts "COULDN'T GET CHILDREN"
        else
            render json: { 
                status: :ok, 
                message: 'Success',
                directories: @directory.children
               }
        end
    end

    def delete_file
        
        @file = ActiveStorage::Attachment.find(params[:id])
        if @file.purge
            render json: { 
                status: :ok, 
                message: 'Success',
               }
        end
        
    end

    def file_link
        @file = ActiveStorage::Attachment.find(params[:id])
        @link = url_for(@file)
        if @link
            render json: {
                status: :ok,
                message: 'Success',
                link: @link
            }
        end
        puts @link
    end

    def destroy
        @directory = Directory.find_by(id: params[:id])

        if !@directory.destroy
            render json: { message: "COULDN'T DELETE DIRECTORY", status: :not_found }
            puts "COULDN'T DELETE DIRECTORY"
        else
            render json: { 
                status: :ok, 
                message: 'Success',
               }
        end

        #redirect_to root_path
        # redirect_to request.referrer
        
    end

    def edit_name
        @directory = Directory.find_by(id: directory_update_params[:id])
    end

    def update_name
        puts directory_update_params
        @directory = Directory.find_by(id: directory_update_params[:id])
        if !@directory.update(directory_update_params)
            render json: { message: "COULDN'T RENAME DIRECTORY", status: :not_found }
            puts "COULDN'T DELETE DIRECTORY"
            # redirect_to request.referrer
        else
            render json: { 
                status: :ok, 
                message: 'Success',
               }
            # render :edit_name
        end
    end

    def update
        @directory = Directory.find_by(id: params[:upload][:parent_id])
        # puts params[:files]
        @directory.files.attach(params[:upload][:files])
        
        if @directory.save
            render json: {
                status: :ok,
                message: 'Success',
                files: @directory.files
            }
            #redirect_to @article
            # redirect_to request.referrer
        else
            render json: { message: "COULDN'T UPLOAD FILE", status: :not_found }
            puts "COULDN'T UPLOAD FILE"
            # render :edit
        end
        
    end

    def get_files
        @directory= Directory.find_by(id: params[:id])
        puts @directory
        @files_json = []
        @files = @directory.files_attachments
        @files.map {|i| i}
        @filenames = @files.map { |i| [i.filename.as_json, i.id] }
        # @filenames
        # puts @filenames
        render json: {
            status: :ok,
            message: 'Success',
            files: @filenames
        }
    end

    def directory_update_params
        params.require(:directory).permit(:name, :id)
    end

    def file_params
        params.require(:directory).permit(:parent_id, :files )
    end

    def directory_params
        params.require(:directory).permit(:name, :parent_id)
    end

end
