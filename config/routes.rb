Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root "homepages#index"
  
  resources :orders
  resources :merchants
  resources :products
  resources :orderitems
  
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create"
end
