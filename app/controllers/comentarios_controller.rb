class ComentariosController < ApplicationController
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
    @comentario = Comentario.new(comentario_params)

    if @comentario.save
      render json: @comentario, status: :created, location: @comentario
    else
      render json: @comentario.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comentarios/1
  def update
    if @comentario.update(comentario_params)
      render json: @comentario
    else
      render json: @comentario.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comentarios/1
  def destroy
    @comentario.destroy!
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
