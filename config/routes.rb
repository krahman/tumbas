Rails.application.routes.draw do
  resources :books
  devise_for :users
  root 'pages#home'

  get 'dashboard' => "pages#dashboard"
end
