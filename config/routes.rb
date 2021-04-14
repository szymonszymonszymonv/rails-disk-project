Rails.application.routes.draw do
  resources :public
  get '/', to: 'public#home'
end
