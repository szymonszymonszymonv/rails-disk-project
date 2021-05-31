ActiveAdmin.register User do

  permit_params :email, :password, :password_confirmation, directories_attributes: [:id, :_destroy, :name]

  sidebar "Details", only: [:show, :edit] do
    link_to "Directories", admin_user_directories_path(resource)
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password 
      f.input :password_confirmation
    end
    f.actions
  end
  
end
