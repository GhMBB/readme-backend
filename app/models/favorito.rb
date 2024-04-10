# frozen_string_literal: true

# app/models/favorito.rb
class Favorito < ApplicationRecord
  belongs_to :user
  belongs_to :libro
  attribute :favorito, :boolean, default: false
  validates :user_id, presence: { message: 'El ID de usuario no puede estar en blanco' }
  validates :libro_id, presence: { message: 'El ID de libro no puede estar en blanco' }

  attribute :favorito, :boolean, default: false
  def self.create_favorito(params, user)
    return nil if user.nil?

    favorito = Favorito.find_or_initialize_by(libro_id: params[:libro_id], user_id: user.id)
    favorito.favorito = params[:fav]
    favorito.deleted = false
    if favorito.save
      favorito
    else
      favorito.errors
    end
  end

  def update_favorito(params)
    self.favorito = params[:fav]
    save
  end

  def self.buscar_por_usuario_y_libro(libro_id, user_id)
    find_by(libro_id:, user_id:, favorito: true, deleted: false)
  end

  def self.libros_favoritos_por_usuario(params)
    favoritos_query = where(user_id: params[:user_id], favorito: true, deleted: false)
    if params[:busqueda].present?
      favoritos_query = favoritos_query.joins(libro: :user)
                                       .where('LOWER(libros.titulo) LIKE ? OR LOWER(users.username) LIKE ?', "%#{params[:busqueda].downcase}%", "%#{params[:busqueda].downcase}%")
    end
    libros_ids = favoritos_query.pluck(:libro_id)
    favoritos = Libro.where(id: libros_ids, deleted:false).paginate(page: params[:page])

    libros_serializados = favoritos.map { |libro| LibroSerializer.new(libro) }

    { total_pages: favoritos.total_pages,
      total_items: favoritos_query.count,
      last_page: params[:page] == favoritos.total_pages,
      favoritos: libros_serializados }
  end
end
