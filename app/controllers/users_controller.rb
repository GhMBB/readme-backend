# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_request
  before_action :set_user, only: %i[show]

  #rescue_from StandardError, with: :internal_server_error

  # GET /users/1
  def show
    @user = get_user
    message, status = @user.show(params, @user)
    render json: message, status: status, serializer: nil
  end

  def update_password
    @user = get_user
    message, status = @user.update_password(params, @user)
    render json: message, status: status
  end

  def update_username
    @user = get_user
    message, status = @user.update_username(params, @user)
    render json: message, status: status
  end

  def update_profile
    @user = get_user
    message, status = @user.update_profile(params, @user)
    render json: message, status: status
  end

  def destroy_profile
    @user = get_user
    message, status = @user.delete_profile(@user)
    render json: message, status: status
  end

  def update_portada
    user = get_user
    message, status = user.update_portada(params, user)
    render json: message, status: status
  end

  def destroy_portada
    @user = get_user
    message, status = @user.delete_portada(@user)
    render json: message, status: status
  end

# GET /users/byUsername
def get_user_by_username
  @user = User.find_by(username: params[:username], deleted: false)
  actual_user = get_user

  if @user.present?
    seguidor = Seguidor.exists?(follower_id: actual_user.id, followed_id: @user.id,deleted:false)
    seguido = Seguidor.exists?(follower_id: @user.id, followed_id: actual_user.id,deleted:false)
    user_data = UserSerializer.new(@user)

    render json: user_data.serializable_hash.merge(seguidor: seguidor, seguido: seguido), status: :ok
  else
    render json: { error: 'Usuario no encontrado' }, status: :unprocessable_entity
  end
end


  def find_by_username
    @user = User.where("username ILIKE ? and deleted = ?", "%#{params[:username]}%", false).paginate(page: params[:page], per_page: WillPaginate.per_page)
    user = @user.map { |user| UserSerializer.new(user)  }
    data = {
      total_pages: @user.total_pages,
      total_items: @user.count,
      users: user
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

  def update_redes_sociales
    @user = get_user
    @persona = @user.persona
    if params[:redes_sociales].nil?
      return render json: {error: "Debe proporcionar el valor para las redes sociales"}, status: 400
    end
    if @persona.update(redes_sociales: params[:redes_sociales])
      render json: @user, status: :ok
    else
      render json: @persona.errors, status: :unprocessable_entity
    end
  end

  def update_visbility
    @user = get_user
    @persona = @user.persona
    if @persona.update(visibility_params)
      render json: @user, status: :ok
    else
      render json: @persona.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/
  def destroy
    @user = get_user
    usuario_a_eliminar = User.find_by(id: params[:id])
    message, status =  @user.delete_user(@user, usuario_a_eliminar, params )
    render json: message, status: status
  end
  def destroy_account
    @user = get_user
    message, status =  @user.eliminar_cuenta(@user, params)
    render json: message, status: status
  end

  def desbanear
    @user = get_user
    unless @user.role == "moderador" || @user.role == "administrador"
      return render json: {error: "Rol de moderador Requerido"}, status: :forbidden
    end
    message, status = @user.desbanear(params[:id])
    render json: message, status: status
  end

  def cambiar_rol
    @user = get_user
    unless @user.role == "administrador"
      return render json: {error: "Rol de administrador Requerido"}, status: :forbidden
    end
    message, status = @user.cambiar_rol(params[:id],params[:role])
    render json: message, status: status
  end

  def find_follow
    user = get_user
    siguiendo = user.followed_relationships.exists?(followed_id: params[:user_id])
    te_sigue = user.follower_relationships.exists?(follower_id: params[:user_id])
    data = {
      siguiendo: siguiendo,
      te_sigue: te_sigue
    }
    render json: data
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def persona_params
    params.permit(:fecha_de_nacimiento, :descripcion, :nacionalidad, :direccion, :nombre, :redes_sociales)
  end

  def visibility_params
    params.permit(:mostrar_datos_personales,:mostrar_lecturas,:mostrar_seguidores,:mostrar_seguidos)
  end
end
