class ComentarioSerializer < ActiveModel::Serializer
  attributes :id, :comentario, :created_at, :username, :profile

  def username
    object.user.username if object.user
  end

  def profile
    obtener_perfil(object.user.persona.profile)
  end

  private
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
