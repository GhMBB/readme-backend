Rails.application.routes.draw do
  post '/login', to: 'auth#login'
  post '/register', to: 'auth#register'
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
