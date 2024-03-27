class Persona < ApplicationRecord
  belongs_to :user
  def update_profile(profile)
    if profile.present?
      cloudinary_response = Cloudinary::Uploader.upload(profile, :folder => "fotosPerfil")

      if cloudinary_response['public_id'].present?
        update(profile: cloudinary_response['public_id'])
        return { message: 'Perfil actualizado exitosamente' }, status: :ok
      else
        render json: { error: 'No se pudo guardar la imagen.' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Se debe pasar el perfil' }, status: 400
    end
  end
end
