  class Libro < ApplicationRecord
    belongs_to :user

    validates :titulo, presence: { message: "El libro debe tener un titulo" }
    validates :categoria, presence: {message: "El libro debe tener una categoría"}

    has_many :capitulos
    has_many :resenhas
    has_many :favoritos
  end
