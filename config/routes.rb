Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root "homepages#index"
  
  resources :orders
  get "/orders/:id/cart", to: "orders#cart", as: "cart"
  get "/orders/:id/checkout", to: "orders#edit", as: "checkout"
  resources :merchants
  resources :orderitems
  resources :categories, only: [:show, :index, :new, :create]
  resources :products do
    resources :reviews, except: [:index] 
  end
  
  get "/auth/github", as: "github_login"
  get "/auth/github/callback", to: "merchants#create"
  delete "/logout", to: "merchants#destroy", as: "logout"
end
