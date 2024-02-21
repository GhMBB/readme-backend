class LibroSerializer < ActiveModel::Serializer
  attributes :id, :titulo, :sinopsis, :portada, :adulto, :puntuacion_media, :cantidad_comentarios, :portada_url, :token, :dropbox_id
  has_one :user
end
