class ResenhasController < ApplicationController
  before_action :authenticate_request
  before_action :set_resenha, only: %i[ show update destroy ]

  # GET /resenhas
  def index
    @resenhas = Resenha.all

    render json: @resenhas
  end

  # GET /resenhas/1
  def show
    render json: @resenha
  end

  # POST /resenhas
  def create
    @resenha = Resenha.new(resenha_params)

    if @resenha.save
      render json: @resenha, status: :created, location: @resenha
    else
      render json: @resenha.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /resenhas/1
  def update
    if @resenha.update(resenha_params)
      render json: @resenha
    else
      render json: @resenha.errors, status: :unprocessable_entity
    end
  end

  #DELETED /resenhas/1
  #Realizar comprobacion de negativos y rollback
def destroy
  user = get_user
  resenha = @resenha
  if (resenha.user_id != user.id) && (user.role != "moderador")
    render json: { error: "El usuario no puede eliminar la resenha de otro usuario" }, status: 403
    return
  end
  if (!resenha.nil?) && (resenha.deleted != true)
    libro = Libro.find(resenha.libro_id)
    libro.cantidad_resenhas -= 1
    libro.sumatoria = libro.sumatoria.to_f - resenha.puntuacion
    libro.puntuacion_media = libro.cantidad_resenhas > 0 ? libro.sumatoria.to_f / libro.cantidad_resenhas : 0
    libro.update(cantidad_resenhas: libro.cantidad_resenhas, sumatoria: libro.sumatoria, puntuacion_media: libro.puntuacion_media)
    resenha.update(deleted: true)
    render json: { message: "Eliminado exitosamente" }, status: :ok
  else
    render json: { error: "La reseña no se encontró" }, status: :not_found
  end
end


  # POST /resenhas
  def create_or_update
    libro_id = params[:libro_id]
    puntuacion = params[:puntuacion].to_f
    #Verificar los parametros
    user = get_user

    libro = Libro.find(libro_id)
    if libro.nil?
      render json: { error: "El libro no fue encontrado" }, status: :not_found
      return
    end

    # Buscar una reseña existente para el libro y usuario dados
    @resenha = Resenha.find_by(user_id: user.id, libro_id: libro_id)

    # Si no existe una reseña, crear una nueva
    if @resenha.nil?
      @resenha = Resenha.create(user_id: user.id, libro_id: libro_id, puntuacion: puntuacion)

      # Actualizar el campo cantidad_resenhas del libro
    libro.update(cantidad_resenhas: (libro.cantidad_resenhas.to_f + 1), sumatoria: (libro.sumatoria.to_f + puntuacion))


    if libro.cantidad_resenhas.present? && libro.cantidad_resenhas != 0
      libro.update(puntuacion_media: (libro.sumatoria.to_f / libro.cantidad_resenhas))
    end

      render json: { message: 'Reseña creada exitosamente', resenha: ResenhaSerializer.new(@resenha)}, status: :created
    else
      # Si ya existe una reseña, actualizarla
      puntuacion_anterior = @resenha.puntuacion
      @resenha.update(puntuacion: puntuacion)

      # Si la resenha fue eliminada anteriormente
      if @resenha.deleted == true
        @resenha.update(deleted: false)
        libro.update(cantidad_resenhas: (libro.cantidad_resenhas + 1))
      end
      #Actualizar la sumatoria
       libro.update(sumatoria: (libro.sumatoria.to_f + puntuacion - puntuacion_anterior))

      # Recalcular la puntuacion_media del libro
      if libro.cantidad_resenhas.present? && libro.cantidad_resenhas != 0
        libro.update(puntuacion_media: (libro.sumatoria.to_f / libro.cantidad_resenhas))
      end

      render json: { message: 'Reseña actualizada exitosamente', resenha: ResenhaSerializer.new(@resenha) } ,status: 201
    end

  end


  def find_by_user_and_libro
    #Verificar los parametros
    #
    libro = Libro.find_by(id: params[:libro_id])
    if libro.nil?
      render json: { error: "El libro no fue encontrado" }, status: 404
      return
    end
    usuario = User.find_by(id: params[:user_id])
    if usuario.nil?
      render json: { error: "El usuario no fue encontrado" }, status: :bad_request
      return
    end

   @resenha = Resenha.find_by(user_id: params[:user_id], libro_id: params[:libro_id], deleted: false)
    if @resenha
      render json: @resenha, status: :ok
    else
      render json: { error: 'Resenha no encontrada' }, status: :not_found
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resenha
      @resenha = Resenha.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def resenha_params
      params.require(:resenha).permit(:user_id, :libro_id, :puntuacion => integer)
    end
end
