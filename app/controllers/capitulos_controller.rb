class CapitulosController < ApplicationController
  before_action :set_capitulo, only: %i[ show update destroy ]

  # GET /capitulos
  def index
    @capitulos = Capitulo.all

    render json: @capitulos
  end

  # GET /capitulos/1
  def show
    render json: @capitulo
  end

  # POST /capitulos
  def create
    @capitulo = Capitulo.new(capitulo_params)

    if @capitulo.save
      render json: @capitulo, status: :created, location: @capitulo
    else
      render json: @capitulo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /capitulos/1
  def update
    if @capitulo.update(capitulo_params)
      render json: @capitulo
    else
      render json: @capitulo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /capitulos/1
  def destroy
    @capitulo.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_capitulo
      @capitulo = Capitulo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def capitulo_params
      params.require(:capitulo).permit(:libro_id, :titulo, :nombre_archivo)
    end
end
