Rails.application.routes.draw do
  post '/login', to: 'auth#login'
  post '/register', to: 'auth#register'
  get 'favoritos/find_by', to: 'favoritos#buscar_por_usuario_y_libro'
  get 'favoritos/user', to: 'favoritos#libros_favoritos_por_usuario'
  post 'resenhas', to: 'resenhas#create_or_update'
  get 'resenhas/user', to: 'resenhas#find_by_user_and_libro'
  resources :favoritos , only: [:create]
  resources :libros
  resources :resenhas, only: [:destroy]


  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
