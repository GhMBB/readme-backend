# app/controllers/comentarios_controller.rb
class ComentariosController < ApplicationController
  before_action :authenticate_request
  before_action :set_comentario, only: %i[update destroy]

  def create
    user = get_user
    message, status = Comentario.create_comentario(params[:libro_id], params[:comentario], user)
    render json: message, status: status
  end

  def update
    user = get_user
    message, status = @comentario.update_comentario(params[:comentario])
    render json: message, status: status
  end

  def destroy
    user = get_user
    message, status = Comentario.destroy_comentario(@comentario.id, user)
    render json: message, status: status
  end

  def find_by_user_and_libro
    user = get_user
    message, status = Comentario.find_by_user_and_libro(params[:user_id], params[:libro_id], params[:page], params[:size])
    render json: message, status: status
  end

  private

  def set_comentario
    @comentario = Comentario.find(params[:id])
  end

  def comentario_params
    params.permit(:user_id, :libro_id, :comentario)
  end
end
