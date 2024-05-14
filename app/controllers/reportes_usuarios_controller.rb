# app/controllers/reportes_usuarios_controller.rb

class ReportesUsuariosController < ApplicationController
  before_action :set_usuario, only: [:create]
  before_action :set_reporte, only: [:update, :destroy]
  before_action :authenticate_request

  def new
    @reporte = @usuario.reportes.new
  end

  def create
    user = get_user
    result, status = Reporte.create_reporte('usuario', params[:usuario_reportado_id], reporte_params, user)
    render json: result, status: status
  end

  def update
    user = get_user
    result, status = @reporte.update_reporte(reporte_params, user)
    render json: result, status: status
  end

  def destroy
    user = get_user
    result, status = @reporte.destroy_reporte(user)
    render json: result, status: status
  end

  def actualizar_muchos_reportes
    user = get_user
    if user.role != "moderador" && usuario.role != "administrador"
      render json: { error: "Debes ser moderador para actualizar los reportes" }, status: :unprocessable_entity
      return
    end

    unless params[:usuario_reportado_id].present? && params[:estado].present? && params[:nuevo_estado].present? && params[:conclusion].present?
      render json: { error: 'Los parámetros usuario_reportado_id, estado, nuevo_estado y la conclusion son obligatorios' }, status: :unprocessable_entity
      return
    end

    result, status = Reporte.actualizar_muchos_reportes( "usuario",params[:usuario_reportado_id], params[:estado], params[:nuevo_estado], params[:conclusion], user.id)
    render json: result, status: status
  end

  private

  def set_usuario
    @usuario = User.find(params[:usuario_reportado_id])
  end

  def set_reporte
    @reporte = Reporte.find(params[:id])
  end

  def reporte_params
    params.require(:reporte).permit(:id, :user_id,  :motivo, :estado, :categoria, :nuevo_estado, :conclusion)
  end
end
