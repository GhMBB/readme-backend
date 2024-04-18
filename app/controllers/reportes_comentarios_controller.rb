# app/controllers/reportes_comentarios_controller.rb
class ReportesComentariosController < ApplicationController
  before_action :set_comentario, only: [:create]
  before_action :set_reporte, only: [:update, :destroy]
  before_action :authenticate_request

  def create
    user = get_user
    message, status = Reporte.create_reporte("comentario", params[:comentario_id], reporte_params, user)
    render json: message, status: status
  end

  def update
    user = get_user
    message, status = @reporte.update_reporte(reporte_params, user)
    render json: message, status: status
  end

  def destroy
    user = get_user
    message, status = @reporte.destroy_reporte(user)
    render json: message, status: status
  end

  def actualizar_muchos_reportes
    user = get_user
    message, status = Reporte.actualizar_muchos_reportes("comentario", params[:comentario_id], params[:estado], params[:nuevo_estado], params[:conclusion], user.id)
    render json: message, status: status
  end

  private

  def set_comentario
    @comentario = Comentario.find_by(id: params[:comentario_id], deleted: false)
  end

  def set_reporte
    @reporte = Reporte.find_by(id: params[:id], deleted: false)
  end

  def reporte_params
    params.require(:reporte).permit(:id, :motivo, :estado, :categoria, :nuevo_estado, :conclusion)
  end
end
