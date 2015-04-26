Rails.application.routes.draw do
  
  resources :books
  
  devise_for :users
  
  root 'pages#home'

  get 'dashboard' => "pages#dashboard"

  post '/buy/:slug', to: 'transactions#create', as: :buy

  get '/pickup/:guid', to: 'transactions#pickup', as: :pickup

end
