Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root "homepages#index"
  
  get "/cart", to: "orders#cart", as: "cart"
  get "/checkout", to: "orders#edit", as: "checkout"
  get "/confirmation", to: "orders#confirmation", as: "confirmation"
  
  resources :orders
  resources :merchants
  resources :orderitems
  resources :products do
    resources :reviews, except: [:index] 
  end
  
  get "/auth/github", as: "github_login"
  get "/auth/github/callback", to: "merchants#create"
  delete "/logout", to: "merchants#destroy", as: "logout"
end
