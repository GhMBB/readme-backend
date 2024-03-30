# frozen_string_literal: true
class InformeController < ApplicationController
  before_action :authenticate_request

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

  def estadisticas_usuario
    user = get_user
    libros = user.libros

    cantidad_total = FechaLectura.where(libro_id: libros.pluck(:id)).count

    # Calcular el crecimiento en la última semana
    fecha_actual = Date.today
    fecha_inicio_semana_pasada = (fecha_actual - 7.days).beginning_of_day
    cantidad_lecturas_semana_pasada = FechaLectura.where(user_id: user.id, fecha: fecha_inicio_semana_pasada..fecha_actual).count

    # Calcular el crecimiento
    crecimiento =  cantidad_lecturas_semana_pasada.to_f/cantidad_total

    # Contar la cantidad total de favoritos del usuario
    cantidad_total_favitos = Favorito.where(user_id: user.id).count

    # Calcular el crecimiento en la última semana
    cantidad_favoritos_semana_pasada = Favorito.where(user_id: user.id, created_at: fecha_inicio_semana_pasada..fecha_actual).count

    # Contar la cantidad total de comentarios del usuario
    cantidad_total_comentarios = Comentario.where(user_id: user.id).count

    # Calcular el crecimiento en la última semana
    cantidad_comentarios_semana_pasada = Comentario.where(user_id: user.id, created_at: fecha_inicio_semana_pasada..fecha_actual).count

    subquery = Lectura.where(libro_id: Libro.where(user_id: user.id).pluck(:id)).pluck(:user_id).uniq

    # Calcular la edad promedio de los lectores
    edad_promedio = Persona.where(user_id: subquery).average('DATE_PART(\'year\', AGE(fecha_de_nacimiento))').to_f.round(2)
    data = {
      cantidad_vistas_totales: cantidad_total,
      cantidad_vistas_ultima_semana: cantidad_lecturas_semana_pasada,
      cantidad_total_favoritos: cantidad_total_favitos,
      cantidad_favoritos_ultima_semana: cantidad_favoritos_semana_pasada,
      cantidad_total_comentarios: cantidad_total_comentarios,
      cantidad_comentarios_ultima_semana: cantidad_comentarios_semana_pasada,
      edad_promedio: edad_promedio
    }

    render json: data, status: :ok
  end


  private

  def set_lectura
    @lectura = Lectura.find_by(id: params[:id], deleted: false)
  end
end
