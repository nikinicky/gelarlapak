Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/register', to: 'users#register'
      post '/login', to: 'sessions#login'

      resources 'products', only: [:index, :show]
      resources 'carts', except: [:destroy]
      resources 'orders', only: [:index, :create]
    end
  end
end
