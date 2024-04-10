# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :role, :profile, :fecha_de_nacimiento, :portada, :descripcion, :nacionalidad, :direccion,
             :nombre, :created_at

  def username
    if object.deleted == true || object.persona.baneado == true
      'Usuario de Readme'
    else
      object.username
    end
  end
  def fecha_de_nacimiento
    object.persona&.fecha_de_nacimiento
  end

  def nombre
    object.persona&.nombre
  end

  def descripcion
    object.persona&.descripcion
  end

  def nacionalidad
    object.persona&.nacionalidad
  end

  def direccion
    object.persona&.direccion
  end

  def profile
    obtener_perfil(object.persona.profile)
  end

  def portada
    obtener_perfil(object.persona.portada)
  end

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
