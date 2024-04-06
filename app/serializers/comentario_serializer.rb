# frozen_string_literal: true

class ComentarioSerializer < ActiveModel::Serializer
  attributes :id, :comentario, :created_at, :username, :profile

  def username
    object.user&.username
  end

  def profile
    obtener_perfil(object.user.persona.profile)
  end

  private

  def obtener_perfil(perfil_public_id)
    return '' unless perfil_public_id

    begin
      Cloudinary::Utils.cloudinary_url(perfil_public_id.to_s, resource_type: :image,
                                                              expires_at: (Time.now + 3600).to_i)
    rescue CloudinaryException => e
      puts "Error al obtener la portada de Cloudinary: #{e.message}"
      ''
    end
  end
end
