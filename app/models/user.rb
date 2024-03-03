class User < ApplicationRecord
    has_secure_password
  
    validates :fecha_nacimiento, presence: {message: "Debe proporcionar la fecha de nacimiento del usuario."}
    validates :username, presence: { message: "El nombre de usuario no puede estar en blanco" }, uniqueness: { message: "El nombre de usuario ya está en uso" }
    validates :password, length: { minimum: 8, message: "La contraseña debe tener al menos 8 caracteres" }, format: { with: /\A.*(?=.*\d).*\z/, message: "La contraseña debe contener al menos un dígito" }
    validates :role, inclusion: { in: %w(usuario moderador), message: "El rol no es válido" }

    has_many :favoritos
    has_many :libros
    has_many :reportes, -> { where(deleted: false) }, foreign_key: :usuario_reportado_id
    has_many :resenhas
    has_many :comentarios
  end
  