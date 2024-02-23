class LibroSerializer < ActiveModel::Serializer
  attributes :id, :titulo, :sinopsis, :portada, :adulto, :cantidad_lecturas ,:cantidad_resenhas, :puntuacion_media, :cantidad_comentarios, :categoria, :user_id
  #has_one :user
end
