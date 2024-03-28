class Persona < ApplicationRecord
  belongs_to :user

  validates :fecha_de_nacimiento, presence: { message: "Se debe pasar una fecha de nacimiento valida" }
  validates :user_id, presence: { message: "El ID de usuario no puede estar en blanco" }

  attribute :profile, :string, default: ""

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

  private

end
