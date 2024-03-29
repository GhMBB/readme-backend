# frozen_string_literal: true
class InformeController < ApplicationController
  #before_action :authenticate_request

  def lecturas_diarias_por_libro
    libro_id = params[:libro_id]
    fecha_inicio = params[:fecha_inicio]
    fecha_fin = params[:fecha_fin]

    if libro_id.blank? || fecha_inicio.blank? || fecha_fin.blank?
      render json: { error: 'Faltan parámetros' }, status: :unprocessable_entity
      return
    end

    usuarios_por_dia = FechaLectura.where(libro_id: libro_id, fecha: fecha_inicio..fecha_fin)
                                   .group(:fecha)
                                   .distinct(:user_id)
                                   .count(:user_id)

    render json: usuarios_por_dia, status: :ok
  end



  private

  def set_lectura
    @lectura = Lectura.find_by(id: params[:id], deleted: false)
  end
end
