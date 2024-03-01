Rails.application.routes.draw do
  resources :lecturas
  post '/login', to: 'auth#login'
  post '/register', to: 'auth#register'
  #Favoritos
  get 'favoritos/find_by', to: 'favoritos#buscar_por_usuario_y_libro'
  get 'favoritos/user', to: 'favoritos#libros_favoritos_por_usuario'
  #Reseñas
  post 'resenhas', to: 'resenhas#create_or_update'
  get 'resenhas/find_by', to: 'resenhas#find_by_user_and_libro'
  #Comentarios
  get 'comentarios/find_by', to: 'comentarios#find_by_user_and_libro'

  resources :favoritos , only: [:create]
  resources :libros
  resources :resenhas, only: [:destroy]
  resources :capitulos, except: [:index]
  get '/capitulos/libro/:libro_id', to: 'capitulos#libro', as: 'libro_capitulos'
  put '/swap/capitulos', to: 'capitulos#swap', as: 'intercambiar_capitulos'
  put '/capitulos/publicar/:id', to: 'capitulos#publicar', as: "publicar_capitulo"
  resources :comentarios, only: [:create,:update, :destroy]


  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
