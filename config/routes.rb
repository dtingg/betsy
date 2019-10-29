Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root "homepages#index"
  
  get "/cart/:id", to: "orders#cart", as: "cart"
  get "/checkout/:id", to: "orders#edit", as: "checkout"
  
  resources :orders
  resources :merchants, except: [:delete]
  post "/logout", to: "merchants#logout", as: "logout"
  delete "merchants/:id", to: "merchants#destroy"
  
  get "merchants/:id/dashboard", to: "merchants#dashboard", as: "dashboard"
  
  resources :orderitems
  resources :reviews, only: [:new, :create]
  resources :products 
  
  resources :categories, only: [:show, :index, :new, :create]
  resources :products, only: [:show] do
    resources :reviews, only: [:new, :create]
  end
  
  get "/auth/github", as: "github_login"
  get "/auth/github/callback", to: "merchants#create", as: "auth_callback"
  
  
end
