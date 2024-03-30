class Resenha < ApplicationRecord
  belongs_to :user
  belongs_to :libro

  validates :puntuacion, presence: { message: "La puntuación no puede estar vacía" }
  validates :puntuacion, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5, message: "La puntuación debe estar entre 0 y 5" }

  attribute :deleted, :boolean, default: false
  def self.destroy_resenha(resenha_id, user_id)
    resenha = Resenha.find_by(id: resenha_id)
    user = User.find_by(id: user_id)
    return { error: "La reseña no se encontró" }, :not_found if resenha.nil?
    return { error: "El usuario no puede eliminar la reseña de otro usuario" }, :forbidden if (resenha.user_id != user.id && user.role != "moderador")

    libro = Libro.find(resenha.libro_id)
    libro.decrement(:cantidad_resenhas)
    libro.sumatoria = libro.sumatoria.to_f - resenha.puntuacion
    libro.puntuacion_media = libro.cantidad_resenhas > 0 ? libro.sumatoria.to_f / libro.cantidad_resenhas : 0
    libro.save
    resenha.update(deleted: true)
    return { message: "Eliminado exitosamente" }, :ok
  end

  def self.create_or_update_resenha(libro_id, puntuacion, user_id)
    return { error: 'Falta el parámetro de puntuación' }, :unprocessable_entity if puntuacion.blank?

    puntuacion = puntuacion.to_f

    libro = Libro.find_by(id: libro_id)
    return { error: "El libro no fue encontrado" }, :not_found if libro.nil?
    return { error: "La puntuación debe estar en el rango de 0 a 5" }, :unprocessable_entity if puntuacion < 0 || puntuacion > 5

    resenha = Resenha.find_by(user_id: user_id, libro_id: libro_id)

    if resenha.nil?
      resenha = Resenha.create(user_id: user_id, libro_id: libro_id, puntuacion: puntuacion)
      libro.increment(:cantidad_resenhas)
      libro.sumatoria += puntuacion
      libro.puntuacion_media = libro.cantidad_resenhas > 0 ? libro.sumatoria.to_f / libro.cantidad_resenhas : 0
      libro.save
      return { message: 'Reseña creada exitosamente', resenha: ResenhaSerializer.new(resenha) },  :created
    else
      puntuacion_anterior = resenha.puntuacion
      resenha.update(puntuacion: puntuacion)

      if resenha.deleted == true
        resenha.update(deleted: false)
        libro.increment(:cantidad_resenhas)
        libro.sumatoria = libro.sumatoria.to_f + puntuacion
      else
        libro.sumatoria = libro.sumatoria.to_f + puntuacion.to_f - puntuacion_anterior
      end

      libro.puntuacion_media = libro.cantidad_resenhas > 0 ? libro.sumatoria.to_f / libro.cantidad_resenhas : 0
      libro.save

      return { message: 'Reseña actualizada exitosamente', resenha: ResenhaSerializer.new(resenha) }, :created
    end
  end

  def self.find_by_user_and_libro(user_id, libro_id)
    resenha = Resenha.find_by(user_id: user_id, libro_id: libro_id, deleted: false)
    return resenha, :ok if resenha.present?
    return { error: 'Resenha no encontrada' }, :not_found
  end
end