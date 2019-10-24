Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :orders
  resources :merchants
  resources :products
  
  get "/auth/github", as: "github_login"
  get "/auth/github/callback", to: "merchants#create"
  delete "/logout", to: "merchants#destroy", as: "logout"
end
