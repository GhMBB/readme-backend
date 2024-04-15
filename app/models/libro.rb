  class Libro < ApplicationRecord
    belongs_to :user

    attribute :deleted, :boolean, default: false
    attribute :deleted_by_user, :boolean, default: false
    attribute :adulto, :boolean, default: false
    attribute :cantidad_lecturas, :integer, default: 0
    attribute :cantidad_resenhas, :integer, default: 0
    attribute :puntuacion_media, :float, default: 0.0
    attribute :cantidad_comentarios, :integer, default: 0
    attribute :sumatoria, :integer,default: 0
    validates :titulo, presence: { message: "El libro debe tener un titulo" }
    validates :categoria, presence: {message: "El libro debe tener una categoría"}
    validates :categoria, inclusion: { in: ->(libro) { libro.class.categoria.keys }, message: "La categoría seleccionada no es válida" }
    #validate :validar_categoria_existente

    has_many :capitulos
    has_many :resenhas
    has_many :favoritos
    has_many :reportes, -> { where(deleted: false) }, foreign_key: :libro_id
    has_many :lecturas
    has_many :lecturas_terminadas, -> { where(leido: true,deleted: false) }, class_name: "Lectura"
    has_many :fecha_lecturas

    enum categoria: {
      ciencia_ficción: "Ciencia ficción",
      Fantasia: "Fantasía",
      Romance: "Romance",
      Terror: "Terror",
      Drama: "Drama",
      Aventura: "Aventura",
      Misterio: "Misterio",
      Humor: "Humor",
      Historica: "Histórica",
      Policial: "Policial",
      Suspenso: "Suspenso",
      Biografia: "Biografía",
      Autobiografia: "Autobiografía",
      Ensayo: "Ensayo",
      Cuentos: "Cuentos",
      Poesia: "Poesía",
      Infantil: "Infantil",
      Juvenil: "Juvenil"
    }

    def cantidad_total_lecturas(libro_id)
        fecha_lecturas.where(libro_id: libro_id).count
    end

    def self.delete_portada(public_id)
        return if public_id.blank?
        cloudinary_response = Cloudinary::Uploader.destroy(public_id)
        unless cloudinary_response['result'] == 'ok'
            # render json: { error: 'No se pudo eliminar la foto de perfil.' }, status: :unprocessable_entity
        end
        ''
    end
=begin
    def validar_categoria_existente
        if categoria.present? && !self.class.categorias.keys.include?(categoria)
            errors.add(:categoria, "La categoría seleccionada no es válida")
        elsif categoria.blank?
            errors.add(:categoria, "El libro debe tener una categoría")
        end
    end
=end
  end
