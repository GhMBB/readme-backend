  class Libro < ApplicationRecord
    belongs_to :user

    attribute :deleted, :boolean, default: false
    attribute :adulto, :boolean, default: false
    attribute :cantidad_lecturas, :integer, default: 0
    attribute :cantidad_resenhas, :integer, default: 0
    attribute :puntuacion_media, :float, default: 0.0
    attribute :cantidad_comentarios, :integer, default: 0
    attribute :sumatoria, :integer,default: 0
    validates :titulo, presence: { message: "El libro debe tener un titulo" }
    validates :categoria, presence: {message: "El libro debe tener una categoría"}

    has_many :capitulos
    has_many :resenhas
    has_many :favoritos
    has_many :reportes, -> { where(deleted: false) }, foreign_key: :libro_id
    has_many :lecturas
  end
