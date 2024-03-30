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

  resources :favoritos , only: [:create, :update]
  resources :libros
  resources :resenhas, only: [:destroy]
  resources :capitulos, except: [:index]
  get '/capitulos/libro/:libro_id', to: 'capitulos#libro', as: 'libro_capitulos'
  put '/swap/capitulos', to: 'capitulos#swap', as: 'intercambiar_capitulos'
  put '/capitulos/publicar/:id', to: 'capitulos#publicar', as: "publicar_capitulo"
  resources :comentarios, only: [:create,:update, :destroy]

  post 'reportes_comentarios/update_all', to: 'reportes_comentarios#actualizar_muchos_reportes'
  post 'reportes_libros/update_all', to: 'reportes_libros#actualizar_muchos_reportes'
  post 'reportes_usuarios/update_all', to:  'reportes_usuarios#actualizar_muchos_reportes'

  get 'reportes/find_by',to: 'reportes#find_by_params'
  get 'reportes',to: 'reportes#find_with_counts'

  get 'reportes_estados', to: 'reportes#estados'

  get '/libros_en_progreso', to: 'lecturas#libros_en_progreso'
  get '/capitulo_actual', to: 'lecturas#capitulo_actual'

  get '/libros_con_capitulos_no_publicados', to: 'lecturas#libros_con_capitulos_no_publicados'

  get '/lecturas_libro_id', to: 'lecturas#showById'

  resources :reportes_comentarios
  resources :reportes_libros
  resources :reportes_usuarios
  resources :reportes
  resources :lecturas

  put 'users/username', to: 'users#update_username'
  put 'users/password', to: 'users#update_password'
  put 'users/profile', to:  'users#update_profile'
  put 'users/birthday', to: 'users#update_birthday'
  get '/usersFind/:username', to: 'users#get_userByUsername', as: 'user_by_username'
  put 'users/portada', to: 'users#update_portada'
  post 'users/information',to: 'users#update_information'
  resources :users
  get "up" => "rails/health#show", as: :rails_health_check

  get 'informe/lectura', to: 'informe#lecturas_diarias_por_libro'
  get 'informe/estadisticas_usuario', to: 'informe#estadisticas_usuario'

  get 'libros_categorias', to: 'libros#categorias'

  post 'users/delete_profile', to:  'users#destroy_profile'
  post 'users/delete_portada', to:  'users#destroy_portada'
  # Defines the root path route ("/")
  # root "posts#index"
end
