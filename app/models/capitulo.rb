class Capitulo < ApplicationRecord
  belongs_to :libro

  attr_accessor :contenido
  attr_accessor :previous_capitulo_id
  attr_accessor :next_capitulo_id
  attribute :deleted, :boolean, default: false
  attribute :publicado, :boolean, default: false

  validates :titulo, presence: { message: "El capitulo debe tener un titulo" }

  before_create :generar_indice

  has_many :lecturas
  private

  def generar_indice
    ultimo_indice = self.libro.capitulos.maximum(:indice)
    self.indice = ultimo_indice ? ultimo_indice + 1 : 1
  end

  def self.restore_capitulo(user, capitulo_id)
    capitulo = Capitulo.find_by(id: capitulo_id)
    
    if capitulo.nil?
      return [{ errors: "Capitulo no encontrado" }, 404]
    end

    libro = capitulo.libro

    # Verificar si el usuario es el dueño del libro
    if libro.user_id != user.id
      capitulo.errors.add(:base, "Debes ser el dueño del libro")
      return capitulo
    end
  
    # Verificar si el capitulo está eliminado por el usuario
    if capitulo.deleted
        # Verificar si han pasado menos de 30 días desde la última actualización
        if (Time.now - capitulo.updated_at) <= 30.days
            # Actualizar el capitulo
            capitulo.update(deleted: false)
            return capitulo
        else
            capitulo.errors.add(:base, "Han pasado más de 30 días desde la eliminación del capitulo.")
            return capitulo
        end
    else
        capitulo.errors.add(:base, "El capitulo no está eliminado por el usuario.")
        return capitulo
    end
end

end
