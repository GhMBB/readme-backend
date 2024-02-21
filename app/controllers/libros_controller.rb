class LibrosController < ApplicationController
  before_action :set_libro, only: %i[ show update destroy ]

  # GET /libros
  def index
    @libros = Libro.all

    render json: @libros
  end

  # GET /libros/1
  def show
    render json: @libro
  end

  # POST /libros
  def create
    @libro = Libro.new(libro_params)

    if @libro.save
      render json: @libro, status: :created, location: @libro
    else
      render json: @libro.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /libros/1
  def update
    if @libro.update(libro_params)
      render json: @libro
    else
      render json: @libro.errors, status: :unprocessable_entity
    end
  end

  # DELETE /libros/1
  def destroy
    @libro.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_libro
      @libro = Libro.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def libro_params
      params.require(:libro).permit(:titulo, :sinopsis, :portada, :adulto, :puntuacion_media, :cantidad_comentarios, :portada_url, :token, :dropbox_id, :user_id)
    end
end
