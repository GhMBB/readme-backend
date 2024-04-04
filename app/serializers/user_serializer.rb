class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :role, :profile, :fecha_de_nacimiento, :portada, :descripcion, :nacionalidad, :direccion, :nombre

  def fecha_de_nacimiento
    object.persona.fecha_de_nacimiento if object.persona
  end

  def nombre
    object.persona.nombre if object.persona
  end
  def descripcion
    object.persona.descripcion if object.persona
  end
  def nacionalidad
    object.persona.nacionalidad if object.persona
  end
  def direccion
    object.persona.direccion if object.persona
  end
  def profile
    obtener_perfil(object.persona.profile)
  end
  def portada
    obtener_perfil(object.persona.portada)
  end
  def obtener_perfil(perfil_public_id)
    if !perfil_public_id
      return ""
    end

    begin
      enlace_temporal = Cloudinary::Utils.cloudinary_url("#{perfil_public_id}", :resource_type => :image, :expires_at => (Time.now + 3600).to_i)
      return enlace_temporal
    rescue CloudinaryException => e
      puts "Error al obtener la portada de Cloudinary: #{e.message}"
      return ""
    end
  end
end
