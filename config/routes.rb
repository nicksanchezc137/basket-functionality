Rails.application.routes.draw do
  #get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'home/about'
  root 'home#index'
  # Defines the root path route ("/")
  # root "articles#index"
  
  resources :product_catalogues do
    resources :delivery_charges
    resources :offers
  end
  
  resources :delivery_charges
  resources :offers
  
  # Custom basket routes (must come before resources to avoid conflicts)
  post 'baskets/add', to: 'baskets#add', as: 'add_baskets'
  resources :baskets
  resources :basket_line_items
end
