# app/controllers/reportes_libros_controller.rb
class ReportesLibrosController < ApplicationController
  before_action :set_libro, only: [:create]
  before_action :set_reporte, only: [:update, :destroy]
  before_action :authenticate_request

  def create
    user = get_user
    message, status = Reporte.create_reporte("libro",params[:libro_id], reporte_params, user)
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
    message, status = Reporte.actualizar_muchos_reportes("libro",params[:libro_id], params[:estado], params[:nuevo_estado], params[:conclusion], user.id)
    render json: message, status: status
  end

  private

  def set_libro
    @libro = Libro.find(params[:libro_id])
  end

  def set_reporte
    @reporte = Reporte.find(params[:id])
  end

  def reporte_params
    params.require(:reportes_libro).permit(:id, :motivo, :estado, :categoria, :nuevo_estado, :conclusion)
  end
end
