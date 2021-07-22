Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      post '/register', to: 'users#register'
      post '/login', to: 'sessions#login'

      resources 'products', only: [:index, :show]
      resources 'carts', except: [:destroy]
    end
  end
end
