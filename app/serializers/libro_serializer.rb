class LibroSerializer < ActiveModel::Serializer
  attributes :id, :titulo, :sinopsis, :portada, :adulto, :cantidad_lecturas ,:cantidad_resenhas, :puntuacion_media, :cantidad_comentarios, :portada_url, :categoria, :user_id, :sumatoria
  #has_one :user
end
