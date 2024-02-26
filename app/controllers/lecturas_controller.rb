class LecturasController < ApplicationController
  before_action :set_lectura, only: %i[ show update destroy ]

  # GET /lecturas
  def index
    @lecturas = Lectura.all

    render json: @lecturas
  end

  # GET /lecturas/1
  def show
    render json: @lectura
  end

  # POST /lecturas
  def create
    @lectura = Lectura.new(lectura_params)

    if @lectura.save
      render json: @lectura, status: :created, location: @lectura
    else
      render json: @lectura.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /lecturas/1
  def update
    if @lectura.update(lectura_params)
      render json: @lectura
    else
      render json: @lectura.errors, status: :unprocessable_entity
    end
  end

  # DELETE /lecturas/1
  def destroy
    @lectura.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lectura
      @lectura = Lectura.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def lectura_params
      params.require(:lectura).permit(:user_id, :libro_id, :fecha)
    end
end
