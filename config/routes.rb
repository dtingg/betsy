Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root "homepages#index"
  
  resources :orders
  resources :merchants
  resources :orderitems
  resources :reviews, only: [:new, :create]
  resources :products 
  
  resources :products, only: [:show] do
    resources :reviews, only: [:new, :create]
  end

  get "/auth/github", as: "github_login"
  get "/auth/github/callback", to: "merchants#create"
  delete "/logout", to: "merchants#destroy", as: "logout"
end
