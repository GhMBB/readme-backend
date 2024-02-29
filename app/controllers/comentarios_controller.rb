class ComentariosController < ApplicationController
  before_action :authenticate_request
  before_action :set_comentario, only: %i[ show update destroy ]

  # GET /comentarios
  def index
    @comentarios = Comentario.all

    render json: @comentarios
  end

  # GET /comentarios/1
  def show
    render json: @comentario
  end
  # POST /comentarios
  def create
    libro_id = params[:libro_id]
    comentario = params[:comentario]
    #Verificar los parametros
    user = get_user

    libro = Libro.find(libro_id)

    if libro.nil?
      render json: { error: "El libro no fue encontrado" }, status: 400
      return
    else
      @comentario = Comentario.create(user_id: user.id, libro_id: libro_id, comentario: comentario, deleted: false)
      # Actualizar el campo cantidad_comentarios del libro
      libro.update(cantidad_comentarios: (libro.cantidad_comentarios.to_f + 1))
      render json: { message: 'Comentario creado exitosamente', comentario: ComentarioSerializer.new(@comentario)}, status: :created
    end
  end

  # PATCH/PUT /comentarios/1
  def update
    libro_id = params[:libro_id]
    comentario = params[:comentario]
    #Verificar los parametros
    user = get_user

    libro = Libro.find(libro_id)
    if libro.nil?
      render json: { error: "El libro no fue encontrado" }, status: 400
      return
    end
    # Buscar un comentario
    if @comentario.nil? && (@comentario.deleted != true)
      render json: { message: 'Comentario no encontrado', status: 400 }
      return
    else
      @comentario.update(comentario: comentario)
      render json: { message: 'Comentario actualizado exitosamente', comentario: ComentarioSerializer.new(@comentario) } ,status: :ok
    end
  end

 #DELETED /comentario/1
  def destroy
    user = get_user
    comentario = @comentario
    if (comentario.user_id != user.id) && (user.role != "moderador")
      render json: { error: "El usuario no puede eliminar el comentario de otro usuario" }, status: 403
      return
    end
    if (!comentario.nil?) && (comentario.deleted != true)
      libro = Libro.find(comentario.libro_id)
      libro.update(cantidad_comentarios: (libro.cantidad_comentarios - 1 ))
      comentario.update(deleted: true)
      render json: { message: "Eliminado exitosamente" }, status: :ok
    else
      render json: { error: "El comentario no se encontró" }, status: 400
    end
  end

  def find_by_user_and_libro
    # Verificar los parametros
    libro = Libro.find_by(id: params[:libro_id])
    if libro.nil?
      render json: { error: "El libro no fue encontrado" }, status: :bad_request
      return
    end
    if params[:user_id].present?
      usuario = User.find_by(id: params[:user_id])
      if usuario.nil?
        render json: { error: "El usuario no fue encontrado" }, status: :bad_request
        return
      end
      comentarios = Comentario.where(user_id: params[:user_id], libro_id: params[:libro_id], deleted: false).order(created_at: :desc)
    else
      comentarios = Comentario.where(libro_id: params[:libro_id], deleted: false).order(created_at: :desc)
    end
    @comentarios = comentarios.paginate(page: params[:page], per_page: params[:size])
    render json: {
      cant_paginas: @comentarios.total_pages,
      resultado: ActiveModel::Serializer::CollectionSerializer.new(@comentarios, serializer: ComentarioSerializer)
    }, status: 200
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comentario
      @comentario = Comentario.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comentario_params
      params.require(:comentario).permit(:user_id, :libro_id, :comentario)
    end
  end
end
