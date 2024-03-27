# app/controllers/resenhas_controller.rb
class ResenhasController < ApplicationController
  before_action :authenticate_request
  before_action :set_resenha, only: %i[destroy]

  def destroy
    user = get_user
    message, status = Resenha.destroy_resenha(@resenha.id, user)
    render json: message, status: status
  end

  def create_or_update
    user = get_user
    message, status = Resenha.create_or_update_resenha(params[:libro_id], params[:puntuacion], user.id)
    render json: message, status: status
  end

  def find_by_user_and_libro
    user = get_user
    resenha, status = Resenha.find_by_user_and_libro(user.id, params[:libro_id])
    render json: resenha, status: status
  end

  private

  def set_resenha
    @resenha = Resenha.find(params[:id])
  end
end
