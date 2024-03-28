class Comentario < ApplicationRecord
  belongs_to :user
  belongs_to :libro

  has_many :reportes, -> { where(deleted: false) }, foreign_key: :comentario_id

  def self.create_comentario(libro_id, comentario, user)
    libro = Libro.find(libro_id)
    return { error: 'El libro no fue encontrado' }, :bad_request if libro.nil?

    comentario = Comentario.create(user_id: user.id, libro_id: libro_id, comentario: comentario, deleted: false)
    libro.increment(:cantidad_comentarios)
    libro.save
    return { message: 'Comentario creado exitosamente', comentario: comentario }, :created
  end

  def update_comentario(comentario)
    return { error: 'El comentario no se encontró' }, :not_found if self.nil? || self.deleted
    self.update(comentario: comentario)
    return { message: 'Comentario actualizado exitosamente', comentario: self }, :ok
  end

  def self.destroy_comentario(comentario_id, user)
    comentario = Comentario.find(comentario_id)
    return { error: 'El comentario no se encontró' }, :bad_request if comentario.nil? || comentario.deleted
    return { error: 'El usuario no puede eliminar el comentario de otro usuario' }, :forbidden if comentario.user_id != user.id && user.role != 'moderador'

    libro = Libro.find(comentario.libro_id)
    libro.decrement(:cantidad_comentarios)
    libro.save
    comentario.update(deleted: true)
    return { message: 'Eliminado exitosamente' }, :ok
  end

  def self.find_by_user_and_libro(user_id, libro_id, page, size)
    libro = Libro.find_by(id: libro_id)
    return { error: 'El libro no fue encontrado' }, :bad_request if libro.nil?

    comentarios_query = if user_id.present?
                          Comentario.where(user_id: user_id, libro_id: libro_id, deleted: false).order(created_at: :desc)
                        else
                          Comentario.where(libro_id: libro_id, deleted: false).order(created_at: :desc)
                        end
    comentarios = comentarios_query.paginate(page: page, per_page: size)
    return { cant_paginas: comentarios.total_pages, resultado: ActiveModel::Serializer::CollectionSerializer.new(comentarios, serializer: ComentarioSerializer) }, :ok
  end
end
