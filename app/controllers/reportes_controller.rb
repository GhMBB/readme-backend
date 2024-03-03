class ReportesController < ApplicationController
  before_action :set_reporte, only: %i[show update destroy]

  # GET /reportes
  def index
    @reportes = Reporte.all

    render json: @reportes
  end

  # GET /reportes/1
  def show
    render json: @reporte
  end

  # POST /reportes
  def create
    @reporte = Reporte.new(reporte_params)

    if @reporte.save
      render json: @reporte, status: :created, location: @reporte
    else
      render json: @reporte.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reportes/1
  def update
    if @reporte.update(reporte_params)
      render json: @reporte
    else
      render json: @reporte.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reportes/1
  def destroy
    @reporte.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_reporte
    @reporte = Reporte.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def reporte_params
    params.require(:reporte).permit(:user_id, :libro_id, :motivo, :estado)
  end
end
