class LibroSerializer < ActiveModel::Serializer
  attributes :id, :titulo, :sinopsis, :portada, :adulto, :cantidad_lecturas ,:cantidad_resenhas, :puntuacion_media, :cantidad_comentarios, :categoria, :user_id, :autorUsername, :cantidad_capitulos, :cantidad_capitulos_publicados, :cantidad_usuarios_leyeron, :cantidad_usuarios_terminaron


  def autorUsername
    object.user.username if object.user
  end

  def cantidad_capitulos
    object.capitulos.count
  end

  def cantidad_capitulos_publicados
    object.capitulos.where(publicado: true).count
  end

  def portada
    obtener_portada(object.portada)
  end

  def cantidad_usuarios_leyeron
    object.lecturas.distinct.count(:user_id)
  end
  def cantidad_usuarios_terminaron
    object.lecturas_terminadas.distinct.count(:user_id)
  end
  private

  def obtener_portada(portada_public_id)
    return "" unless portada_public_id

    begin
      enlace_temporal = Cloudinary::Utils.cloudinary_url("#{portada_public_id}", resource_type: :image, expires_at: (Time.now + 3600).to_i)
      enlace_temporal
    rescue CloudinaryException => e
      puts "Error al obtener la portada de Cloudinary: #{e.message}"
      ""
    end
  end
end
