Rails.application.routes.draw do
  resources :capitulos
  resources :total_resenhas
  resources :resenhas
  resources :reportes
  resources :comentarios
  resources :favoritos
  resources :libros
  resources :users
  post '/login', to: 'auth#login'
  post '/register', to: 'auth#register'
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
