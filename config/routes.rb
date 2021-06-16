Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'sessions/destroy'
  get 'users/new'
  resources :public, :users, :sessions, :directories, :disk_files

  resources :users do
    resources :directories
  end


  resources :directories do
    member do
      delete :delete_file
    end
  end

  resources :directories do
    member do
      patch :update_name
      put :update_name
    end
  end



  get '/', to: 'public#home'
  
  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  delete '/logout', to: 'sessions#destroy'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  put '/directories/:id', to: 'directories#edit'
  put '/directories/:id/upload', to: 'directories#update'
  get '/directories/:id/upload', to: 'directories#get_files'
  post '/directories', to: 'directories#create'
  get '/directories/:id/children', to: 'directories#show_children'
  delete '/directories/files/:id', to: 'directories#delete_file'
  get '/directories/files/:id', to: 'directories#file_link'
  post '/start', to: 'sessions#get_root'
  root to: 'public#home'
end