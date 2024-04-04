# app/controllers/lecturas_controller.rb

class LecturasController < ApplicationController
  before_action :authenticate_request
  before_action :set_lectura, only: [:destroy]

  def showById
    user = get_user

    if user.nil?
      render json: {error: "El usuario no se encuentra"}, status: 400
      return
    end
    libro_id = params[:libro_id]
    if libro_id.blank?
      return render json: { error: 'Falta el id del libro' }, status: :unprocessable_entity
    end
    @lectura = Lectura.find_by(libro_id: libro_id, user_id: user.id, deleted: false)

    render json: @lectura, status: 200
  end

  def create
    user = get_user
    if user.nil?
      render json: { error: "El usuario no se encuentra" }, status: 400
      return
    end

    response, status = Lectura.create_lectura(params, user)

    render json: response, status: status
  end

  def destroy
    user = get_user
    if @lectura.nil?
      render json: { message: "No existe el progreso de lectura" }, status: 400
      return
    end

    if @lectura.user != user && user.role != "moderador"
      render json: { error: "Debes ser el propietario para editarlo o tener el rol de moderador." }, status: 401
      return
    end

    @lectura.deleted = true
    if @lectura.save
      render json: { message: "Eliminado con éxito" }, status: :ok
    else
      render json: { error: "No se pudo eliminar" }, status: 400
    end
  end

  def capitulo_actual
    user = get_user
    if user.nil?
      render json: { error: "El usuario no se encuentra" }, status: 400
      return
    end

    response, status = Lectura.current_chapter(params, user)

    render json: response, status: status
  end

  def libros_en_progreso
    user = get_user
    if user.nil?
      render json: { error: "El usuario no se encuentra" }, status: 400
      return
    end

    response, status = user.libros_en_progreso(params)

    render json: response, status: status
  end
  def fecha_lectura
    user = get_user
    if user.nil?
      render json: { error: "El usuario no se encuentra" }, status: 400
      return
    end
    response, status = Lectura.crear_fecha_lectura(params, user)
    render json: response, status: status
  end

  def libros_con_capitulos_no_publicados
    user = get_user
    if user.nil?
      render json: { error: "El usuario no se encuentra" }, status: 400
      return
    end

    libros_con_ultimo_capitulo_no_publicado, status = user.libros_con_capitulos_no_publicados(params, user)

    render json: libros_con_ultimo_capitulo_no_publicado, status: 200
  end

  private

  def set_lectura
    @lectura = Lectura.find_by(id: params[:id], deleted: false)
  end
end
