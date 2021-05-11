Rails.application.routes.draw do
  get 'sessions/destroy'
  get 'users/new'
  resources :public, :users, :sessions, :directories

  get '/', to: 'public#home'
  
  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  delete '/logout', to: 'sessions#destroy'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  post '/directories', to: 'directories#create'

  root to: 'public#home'
end
