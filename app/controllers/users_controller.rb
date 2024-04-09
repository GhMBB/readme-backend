# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_request
  #before_action :set_user, only: %i[show]

  #rescue_from StandardError, with: :internal_server_error

  # GET /users/1
  def show
    render json: @user
  end

  def update_password
    @user = get_user
    message, status = User.update_password(params, @user)
    render json: message, status:
  end

  def update_username
    @user = get_user
    message, status = User.update_username(params, @user)
    render json: message, status:
  end

  def update_profile
    @user = get_user
    message, status = User.update_profile(params, @user)
    render json: message, status:
  end

  def destroy_profile
    @user = get_user
    message, status = User.delete_profile(params, @user)
    render json: message, status:
  end

  def update_portada
    user = get_user
    message, status = User.update_portada(params, user)
    render json: message, status:
  end

  def destroy_portada
    @user = get_user
    message, status = User.delete_portada(@user)
    render json: message, status:
  end

  # GET /users/byUsername
  def get_user_by_username
    @user = User.find_by(username: params[:username], deleted: false)
    if @user
      render json: @user, status: :ok
    else
      render json: { error: 'usuario con no encontrado' }, status: :unprocessable_entity
    end
  end

  def find_by_username
    #Agregar paginacion
    @user = User.where("username ILIKE ? and deleted = ?", "%#{params[:username]}%", false).paginate(page: params[:page], per_page: WillPaginate.per_page)
    data = {
      total_pages: @user.total_pages,
      total_items: @user.count,
      users: @user
    }
    render json: data, status: :ok
  end


  def update_information
    @user = get_user
    @persona = @user.persona
    if @persona.update(persona_params)
      render json: @user, status: :ok
    else
      render json: @persona.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/
  def destroy
    @user = get_user
    usuario_a_eliminar = User.find_by(id: params[:id], deleted: false)
    message, status = User.delete_user(@user, usuario_a_eliminar, params)
    render json: message, status:
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def persona_params
    params.permit(:fecha_de_nacimiento, :descripcion, :nacionalidad, :direccion, :nombre)
  end
end
