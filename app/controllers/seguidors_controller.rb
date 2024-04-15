# frozen_string_literal: true

class SeguidorsController < ApplicationController
  before_action :authenticate_request
  before_action :set_seguidor, only: %i[show]
  rescue_from StandardError, with: :internal_server_error
  # GET /seguidors
  def index
    @seguidors = Seguidor.all

    render json: @seguidors
  end

  # GET /seguidors/1
  def show
    render json: @seguidor
  end

  # POST /seguidors
  def create
    @user = get_user
    return render json: { message: 'Debe pasar el id del seguidor' }, status: 400 if params[:followed_id].blank?

    # Crear al verificar si existe o no
    @seguidor = Seguidor.find_by(follower_id: @user.id, followed_id: params[:followed_id])
    if @seguidor.nil?
      @seguidor = Seguidor.new(follower_id: @user.id, followed_id: params[:followed_id])
      if @seguidor.save
        render json: { message: 'creado con exito', seguidors: SeguidorSerializer.new(@seguidor) }, status: :created,
               location: @seguidor
      else
        render json: @seguidor.errors, status: :unprocessable_entity
      end
    elsif @seguidor.update(follower_id: @user.id, followed_id: params[:followed_id], deleted: false)
      render json: { message: 'creado con exito', seguidors: SeguidorSerializer.new(@seguidor) }, status: 200
    else
      render json: @seguidor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /seguidors/1
  #   def update
  #     if @seguidor.update(seguidor_params)
  #       render json: @seguidor
  #     else
  #       render json: @seguidor.errors, status: :unprocessable_entity
  #     end
  #   end

  # DELETE /seguidors/1
  def destroy
    @user = get_user
    @seguidor = Seguidor.find_by(follower_id: @user.id, followed_id: params[:id], deleted: false)
    return render json: { error: 'No se encuentra el seguimiento del usuario' }, status: :not_found if @seguidor.nil?

    if @seguidor.follower_id != @user.id && @user.role != 'moderador'
      return render json: { error: 'El usuario no puede eliminar el seguidor de otro usuario' },
                    status: :forbidden
    end

    if @seguidor.update(deleted: true)
      render json: { message: 'Eliminado con exito' }, status: 200
    else
      render json: { message: 'Error al eliminar' }, status: :bad_request
    end
  end

  # Agregar paginacion a seguidores y seguidos

  def seguidores
    return render json: { errors: 'Debe pasar el user_id' }, status: 400 if params[:user_id].blank?
    actual_user = get_user

    @seguidor = Seguidor.where(followed_id: params[:user_id], deleted: false).paginate(page: params[:page])
    ids = @seguidor.pluck(:follower_id)
    @users = User.where(id: ids)
    @users.map { |user| UserSerializer.new(user) }
    data = {
      total_pages: @seguidor.total_pages,
      last_page: params[:page] == @seguidor.total_pages,
      users: @users.map do |user|
        seguidor = Seguidor.exists?(follower_id: actual_user.id, followed_id: user.id,deleted:false)
        seguido = Seguidor.exists?(follower_id: user.id, followed_id: actual_user.id,deleted:false)
        user_serializer = UserSerializer.new(user)
        user_serializer.serializable_hash.merge(seguidor: seguidor, seguido: seguido)
      end
    }
    render json: data, status: 200, serializer: nil
  end

  # No funciona
  def seguidos
    return render json: { errors: 'Debe pasar el user_id' }, status: 400 if params[:user_id].blank?
    actual_user = get_user

    @seguidor = Seguidor.where(follower_id: params[:user_id], deleted: false).paginate(page: params[:page])
    ids = @seguidor.pluck(:followed_id)
    @users = User.where(id: ids)
    @users.map { |user| UserSerializer.new(user) }
    data = {
      total_pages: @seguidor.total_pages,
      last_page: params[:page] == @seguidor.total_pages,
      users: @users.map do |user|
        seguidor = Seguidor.exists?(follower_id: actual_user.id, followed_id: user.id,deleted:false)
        seguido = Seguidor.exists?(follower_id: user.id, followed_id: actual_user.id,deleted:false)
        user_serializer = UserSerializer.new(user)
        user_serializer.serializable_hash.merge(seguidor: seguidor, seguido: seguido)
      end
    }
    render json: data, status: 200
  end

  def cant_seguidores
    return render json: { errors: 'Debe pasar el user_id' }, status: 400 if params[:user_id].blank?

    user_id = params[:user_id]
    seguidos = Seguidor.where(follower_id: user_id, deleted: false).count
    seguidores = Seguidor.where(followed_id: user_id, deleted: false).count

    render json: { seguidos:, seguidores: }, status: 200
  end

  # Eliminar seguidor de un usuario
  def destroy_follower
    @user = get_user
    if @user.nil?
      render json: { error: 'El usuario no se encuentra' }, status: 400
      return
    end
    @seguidor = Seguidor.find_by(followed_id: @user.id, follower_id: params[:id], deleted: false)
    return render json: { error: 'No se encuentra el seguimiento del usuario' }, status: :not_found if @seguidor.nil?

    if @seguidor.followed_id != @user.id && @user.role != 'moderador'
      return render json: { error: 'El usuario no puede eliminar el seguidor de otro usuario' },
                    status: :forbidden
    end

    if @seguidor.update(deleted: true)
      render json: { message: 'Eliminado con exito' }, status: 200
    else
      render json: { message: 'Error al eliminar' }, status: :bad_request
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_seguidor
    @seguidor = Seguidor.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def seguidor_params
    params.permit(:follower_id, :followed_id)
  end
end
