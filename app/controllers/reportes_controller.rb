# frozen_string_literal: true

# app/controllers/reportes_controller.rb

class ReportesController < ApplicationController
  before_action :authenticate_request
  #before_action :authorize_moderador
  #{}rescue_from StandardError, with: :internal_server_error

  def find_by_params
    reportes , status= Reporte.includes(:comentario, :user, :libro).order(created_at: :desc).find_by_params(params)
    render json:  reportes, status: status
  end

  def find_with_counts
    reportes, status = Reporte.find_with_counts(params)
    render json: reportes, status: status
  end

  def estados
    estado_enum = Reporte.estados
    @estados = estado_enum.keys.map { |key| [key.to_s, estado_enum[key]] }
    render json: @estados, status: :ok
  end

  def repCatLibros
    @categorias = BookReportCategory.all.select('id', 'name')
    # serialized_categorias = @categorias.map { |e| ReporteCategoriaSerializer.new(e) }
    render json: @categorias, status: :ok
  end

  def repCatComentarios
    @categorias = CommentReportCategory.all.select('id', 'name')
    render json: @categorias, status: :ok
  end

  def repCatUsuarios
    @categorias = UserReportCategory.all.select('id', 'name')
    render json: @categorias, status: :ok
  end

  def getAllByUserId
    usuario = get_user
    if !(usuario.role == "administrador") && !(usuario.role == "moderador") && !(usuario.id == params[:id])
      return render json: {error: "No tiene los permisos requeridos"}, status: 401
    end
    message, status = Reporte.getAllByUserId(params[:id],params)
    render json: message, status: status
  end

  #   def repCategorias
  #     @categorias =  BookReportCategory.all + CommentReportCategory.all +  UserReportCategory.all
  #     render json: @categorias, status: :ok
  #   end

  private

  # Only allow a list of trusted parameters through.
  def reporte_params
    params.require(:reporte).permit(:user_id, :libro_id, :motivo, :estado, :categoria, :usuario_reportado_id)
  end
end
