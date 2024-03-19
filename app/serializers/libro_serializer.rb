class LibroSerializer < ActiveModel::Serializer
  attributes :id, :titulo, :sinopsis, :portada, :adulto, :cantidad_lecturas ,:cantidad_resenhas, :puntuacion_media, :cantidad_comentarios, :categoria, :user_id, :autorUsername, :cantidad_capitulos, :cantidad_capitulos_publicados


  def autorUsername
    object.user.username if object.user
  end

  def cantidad_capitulos
    object.capitulos.count
  end

  def cantidad_capitulos_publicados
    object.capitulos.where(publicado: true).count
  end


end
