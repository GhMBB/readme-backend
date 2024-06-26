# frozen_string_literal: true

class LibroSerializer < ActiveModel::Serializer
  attributes :id, :titulo, :sinopsis, :portada, :adulto, :cantidad_lecturas, :cantidad_resenhas, :puntuacion_media,
             :cantidad_comentarios, :categoria, :user_id, :autorUsername, :cantidad_capitulos, :cantidad_capitulos_publicados, :cantidad_usuarios_leyeron, :cantidad_usuarios_terminaron,
             :notificacion

  def autorUsername
    if object.user&.deleted == true || object.user&.persona.baneado == true
      'Usuario de Readme'
    else
      object.user&.username
    end
  end

  def cantidad_lecturas
    object.cantidad_total_lecturas(object.id)
  end

  def cantidad_capitulos
    object.capitulos.count
  end

  def cantidad_capitulos_publicados
    object.capitulos.where(publicado: true, deleted: false).count
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
  
  def notificacion
    return !NotificacionDeCapitulo.find_by(user_id: instance_options[:usuario_id], libro_id: object.id, deleted: false).nil?
  end
  
  private

  def obtener_portada(portada_public_id)
    return '' unless portada_public_id

    begin
      Cloudinary::Utils.cloudinary_url(portada_public_id.to_s, resource_type: :image,
                                                               expires_at: (Time.now + 3600).to_i)
    rescue CloudinaryException => e
      puts "Error al obtener la portada de Cloudinary: #{e.message}"
      ''
    end
  end
end
