Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :orders
  resources :merchants
  resources :products do
    resources :reviews
  end
  
  resources :reviews
  
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create"
end
