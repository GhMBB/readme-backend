class ReportesController < ApplicationController
  before_action :authenticate_request
  before_action :authorize_moderador
  def find_by_params
    query = Reporte.all
    query = query.where(deleted: false)
    query = query.where(estado: params[:estado]) if params[:estado].present?
    query = query.where(motivo: params[:motivo]) if params[:motivo].present?
    query = query.where(categoria: params[:categoria]) if params[:categoria].present?
    query = query.where(libro_id: params[:libro_id]) if params[:libro_id].present?
    query = query.where(comentario_id: params[:comentario_id]) if params[:comentario_id].present?
    query = query.where(usuario_reportado_id: params[:usuario_reportado_id]) if params[:usuario_reportado_id].present?

    reportes = query
    render json: { reportes: reportes }, status: :ok
  end

  def find_with_counts
    query = Reporte.select( :libro_id, :comentario_id,:usuario_reportado_id, 'COUNT(*) as total_reportes')
                   .where(deleted: false)
                   .group(:libro_id, :comentario_id, :usuario_reportado_id)

    render json: query, status: :ok
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
