class Persona < ApplicationRecord
  belongs_to :user

  validates :fecha_de_nacimiento, presence: { message: "Se debe pasar una fecha de nacimiento valida" }
  validates :user_id, presence: { message: "El ID de usuario no puede estar en blanco" }
  #validates :email, uniqueness: { message: "El email ya está en uso" }

  attribute :profile, :string, default: ""

  def self.actualizar_email_nil
    personas_a_actualizar = Persona.where("fecha_eliminacion < ?", 30.days.ago)
    personas_a_actualizar.update_all(email: nil)
  end
  private

end
