class Capitulo < ApplicationRecord
  belongs_to :libro
  belongs_to :previous_capitulo, class_name: 'Capitulo', optional: true
  belongs_to :next_capitulo, class_name: 'Capitulo', optional: true
  
  attr_accessor :contenido
  attribute :deleted, :boolean, default: false
  attribute :publicado, :boolean, default: false

  validates :titulo, presence: { message: "El capitulo debe tener un titulo" }

  before_create :generar_indice

  private

  def generar_indice
    ultimo_indice = self.libro.capitulos.maximum(:indice)
    self.indice = ultimo_indice ? ultimo_indice + 1 : 1
  end
end
