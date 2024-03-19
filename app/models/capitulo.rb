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
end
