# frozen_string_literal: true
class InformeController < ApplicationController
  #before_action :authenticate_request
  def lecturas_diarias_por_libro
    libro_id = params[:libro_id]
    fecha_inicio = params[:fecha_inicio]
    fecha_fin = params[:fecha_fin]
    lecturas_diarias = Lectura.where(libro_id: libro_id, updated_at: fecha_inicio..fecha_fin)
                              .group(:updated_at)
                              .count
    render json: lecturas_diarias
  end

  private

  def set_lectura
    @lectura = Lectura.find_by(id: params[:id], deleted: false)
  end
end
