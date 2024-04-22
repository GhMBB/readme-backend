# frozen_string_literal: true

Rails.application.routes.draw do
  resources :lecturas, only: %i[create destroy]
  post '/login', to: 'auth#login'
  post '/register', to: 'auth#register'
  # Favoritos
  get 'favoritos/find_by', to: 'favoritos#buscar_por_usuario_y_libro'
  get 'favoritos/user', to: 'favoritos#libros_favoritos_por_usuario'
  # Reseñas
  post 'resenhas', to: 'resenhas#create_or_update'
  get 'resenhas/find_by', to: 'resenhas#find_by_user_and_libro'
  # Comentarios
  get 'comentarios/find_by', to: 'comentarios#find_by_user_and_libro'

  resources :favoritos, only: %i[create update]
  resources :libros
  resources :resenhas, only: [:destroy]
  resources :capitulos, except: [:index]
  get '/capitulos/libro/:libro_id', to: 'capitulos#libro', as: 'libro_capitulos'
  put '/swap/capitulos', to: 'capitulos#swap', as: 'intercambiar_capitulos'
  put '/capitulos/publicar/:id', to: 'capitulos#publicar', as: 'publicar_capitulo'
  resources :comentarios, only: %i[create update destroy]

  post 'reportes_comentarios/update_all', to: 'reportes_comentarios#actualizar_muchos_reportes'
  post 'reportes_libros/update_all', to: 'reportes_libros#actualizar_muchos_reportes'
  post 'reportes_usuarios/update_all', to: 'reportes_usuarios#actualizar_muchos_reportes'

  get 'reportes/find_by', to: 'reportes#find_by_params'
  get 'reportes', to: 'reportes#find_with_counts'

  get 'reportes/estados/', to: 'reportes#estados'

  get '/libros_en_progreso', to: 'lecturas#libros_en_progreso'
  get '/capitulo_actual', to: 'lecturas#capitulo_actual'

  get '/libros_con_capitulos_no_publicados', to: 'lecturas#libros_con_capitulos_no_publicados'

  get '/lecturas_libro_id', to: 'lecturas#showById'

  resources :reportes_comentarios, only: %i[create update destroy]
  resources :reportes_libros, only: %i[create update destroy]
  resources :reportes_usuarios, only: %i[create update destroy]
  resources :reportes, only: []
  resources :lecturas, only: %i[create destroy]

  put 'users/username', to: 'users#update_username'
  put 'users/password', to: 'users#update_password'
  put 'users/profile', to:  'users#update_profile'
  get '/usersFind/:username', to: 'users#get_user_by_username', as: 'user_by_username'
  put 'users/portada', to: 'users#update_portada'
  put 'users/information', to: 'users#update_information'
  resources :users, only: %i[show destroy]
  get 'up' => 'rails/health#show', as: :rails_health_check

  get 'informe/lectura', to: 'informe#lecturas_diarias_por_libro'
  get 'informe/estadisticas_usuario', to: 'informe#estadisticas_usuario'

  get 'libros_categorias', to: 'libros#categorias'

  post 'users/delete_profile', to:  'users#destroy_profile'
  post 'users/delete_portada', to:  'users#destroy_portada'

  post 'lecturas/createfecha', to:  'lecturas#fecha_lectura'

  resources :seguidors, except: [:update]

  get 'seguidores', to: 'seguidors#seguidores'
  get 'seguidos', to: 'seguidors#seguidos'
  get 'cantseguidores', to: 'seguidors#cant_seguidores'
  delete 'seguidors/seguidor/:id', to: 'seguidors#destroy_follower'

  get 'reportes/categorias/comentarios', to: 'reportes#repCatComentarios'
  get 'reportes/categorias/libros', to: 'reportes#repCatLibros'
  get 'reportes/categorias/usuarios', to: 'reportes#repCatUsuarios'
  get 'reportes/categorias', to: 'reportes#repCategorias'

  get 'lecturas/lista_lecturas', to: 'lecturas#lista_de_lectura'

  delete 'libros/eliminar_portada/:id',to: 'libros#destroy_portada'

  get 'users/find_by_username/:username', to: 'users#find_by_username'

  delete 'users/delete_account/:id', to: 'users#destroy_account'
  delete 'users/ban/:id', to: 'users#destroy'
  post 'users/desbanear/:id', to: 'users#desbanear'

  get 'users/findfollowrelationship/:user_id',to: 'users#find_follow'

  #auth 2.0
  post 'auth/register', to: 'auth#register_with_email'
  post 'auth/email_confirmation', to: 'auth#email_confirmation'
  post 'auth/login', to: 'auth#login_with_email'
  get 'auth/forgot_password', to: 'auth#send_reset_password_email'
  post 'auth/reset_password', to: 'auth#reset_password'
  get 'auth/resent_email_confirmation', to: 'auth#reenviar_email_confirmacion'

  get '/papelera', to: "papelera#index"
  # Defines the root path route ("/")
  # root "posts#index"
end
