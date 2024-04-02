# app/controllers/reportes_controller.rb

class ReportesController < ApplicationController
  before_action :authenticate_request
  before_action :authorize_moderador

  def find_by_params
    reportes = Reporte.find_by_params(params)
    render json: { reportes: reportes }, status: :ok
  end

  def find_with_counts
    reportes = Reporte.find_with_counts
    render json: reportes, status: :ok
  end

  def estados
    estado_enum = Reporte.estados
    @estados = estado_enum.keys.map { |key| [key.to_s, estado_enum[key]] }
    render json: @estados
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_reporte
    @reporte = Reporte.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def reporte_params
    params.require(:reporte).permit(:user_id, :libro_id, :motivo, :estado, :categoria, :usuario_reportado_id)
  end
end
