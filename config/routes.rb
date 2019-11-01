Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root "homepages#index"
  get "/search", to: "homepages#search", as: "search"
  
  get "/cart", to: "orders#cart", as: "cart"
  get "/checkout/:id", to: "orders#edit", as: "checkout"
  resources :orders, except: [:index, :new, :create, :put, :delete]
  
  resources :merchants, only: [:index, :show]
  post "/logout", to: "merchants#logout", as: "logout"
  get "/dashboard", to: "merchants#dashboard", as: "dashboard"
  
  resources :orderitems, except: [:index, :put, :new, :show]
  patch "/orderitems/:id/cancel/", to: "orderitems#cancel", as: "cancel"
  
  resources :products, except: [:put]
  resources :products, only: [:show] do
    resources :reviews, only: [:new, :create]
  end
  
  resources :reviews, only: [:new, :create]
  
  resources :categories, only: [:show, :index, :new, :create]
  
  get "/auth/github", as: "github_login"
  get "/auth/github/callback", to: "merchants#create", as: "auth_callback"
end
