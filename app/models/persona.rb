class Persona < ApplicationRecord
  belongs_to :user
  has_secure_token :confirmation_token
  validates :fecha_de_nacimiento, presence: { message: "Se debe pasar una fecha de nacimiento valida" }
  validates :user_id, presence: { message: "El ID de usuario no puede estar en blanco" }
  attribute :profile, :string, default: ""
  attribute :email_confirmed,:boolean, default: false
  attribute :redes_sociales, default: ""

  def self.actualizar_email_nil
    personas_a_actualizar = Persona.where("fecha_eliminacion < ?", 30.days.ago)
    personas_a_actualizar.update_all(email: nil)
  end

  def regenerate_confirmation_token!
    self.regenerate_confirmation_token # Genera un nuevo token de confirmación
    self.save # Guarda el registro actualizado en la base de datos
  end

  private
end
