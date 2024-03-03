# frozen_string_literal: true
class ReportesUsuariosController < ApplicationController
    before_action :set_usuario,only: [:create]
    before_action :set_reporte, only: [ :update, :destroy]
    before_action :authenticate_request

    def new
      @reporte = @usuario.reportes.new
    end

    def create
      @reporte = @usuario.reportes.new(reporte_params)
      if @reporte.save
        render json: { message: 'Reporte creado exitosamente', reporte: ReporteUserSerializer.new(@reporte) }, status: 200
      else
        render json: { errors: @reporte.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      mod = get_user
      if mod.role != "moderador"
        render json: { error: "Debes ser moderador para actualizar los reportes"}, status: :unprocessable_entity
        return
      end
      if @reporte.nil?
        return render json: { message: 'Reporte no encontrado' }, status: 404
      end
      if @reporte.update(reporte_params)
        @reporte.update(moderador_id: mod.id)
        render json: { message: 'Reporte actualizado exitosamente',reporte: ReporteUserSerializer.new(@reporte)  }, status: 200
      else
        render json: { errors: @reporte.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      mod = get_user
      if mod.role != "moderador"
        render json: { error: "Debes ser moderador para eliminar los reportes"}, status: :unprocessable_entity
        return
      end
      if @reporte.nil?
        return render json: { message: 'Reporte no encontrado' }, status: 404
      end
      if @reporte.update(deleted: true, moderador_id: mod.id)
        render json: { message: 'Reporte eliminado exitosamente' }, status: 200
      else
        render json: { errors: @reporte.errors.full_messages }, status: :unprocessable_entity
      end
    end
    def actualizar_muchos_reportes
      mod = get_user
      if mod.role != "moderador"
        render json: { error: "Debes ser moderador para actualizar los reportes"}, status: :unprocessable_entity
        return
      end
      # Comprobando si los parámetros requeridos están presentes
      unless params[:usuario_reportado_id].present? && params[:estado].present? && params[:nuevo_estado].present? && params[:conclusion].present?
        render json: { error: 'Los parámetros usuario_reportado_id, estado,nuevo_estado y la conclusion son obligatorios' }, status: :unprocessable_entity
        return
      end

      reportes = Reporte.where(usuario_reportado_id: params[:usuario_reportado_id], estado: params[:estado], deleted: false)
      actualizar_estado(reportes, params[:nuevo_estado], params[:conclusion], mod.id)
    end
    def actualizar_estado(reportes, nuevo_estado, conclusion, modId)
      reportes.update_all(estado: nuevo_estado, conclusion: conclusion, moderador_id: modId)
      render json: { message: "El estado de los reportes se ha actualizado correctamente" }, status: :ok
    end
    private

    def set_usuario
      @usuario = User.find(params[:usuario_reportado_id])
    end

    def set_reporte
      @reporte = Reporte.find(params[:id])
    end

    def reporte_params
      params.require(:reporte).permit(:user_id,:usuario_reportado_id ,:motivo, :estado, :categoria, :categoria, :nuevo_estado, :conclusion)
    end
  end

