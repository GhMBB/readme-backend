class SeguidorsController < ApplicationController
  before_action :authenticate_request
  before_action :set_seguidor, only: %i[ show ]

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
    if params[:followed_id].blank?
      return render json:  {message: "Debe pasar el id del seguidor"}, status: 400
    end
    #Crear al verificar si existe o no
    @seguidor = Seguidor.find_by(follower_id: @user.id, followed_id: params[:followed_id])
    if @seguidor.nil?
      @seguidor = Seguidor.new(follower_id: @user.id, followed_id: params[:followed_id])
      if @seguidor.save
        render json:{message:"creado con exito", seguidors:  SeguidorSerializer.new(@seguidor) }, status: :created, location: @seguidor
      else
        render json: @seguidor.errors, status: :unprocessable_entity
      end
    else
      if @seguidor.update(follower_id: @user.id, followed_id: params[:followed_id], deleted:  false)
        render json: {message:"creado con exito", seguidors:  SeguidorSerializer.new(@seguidor) }, status: 200
      else
        render json: @seguidor.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /seguidors/1
=begin
  def update
    if @seguidor.update(seguidor_params)
      render json: @seguidor
    else
      render json: @seguidor.errors, status: :unprocessable_entity
    end
  end
=end

  # DELETE /seguidors/1
  def destroy
    @user = get_user
    @seguidor = Seguidor.find_by(follower_id: @user.id, followed_id: params[:id], deleted: false)
    return render json: { error: 'No se encuentra el seguimiento del usuario' }, status: :not_found if @seguidor.nil?
    return render json: { error: 'El usuario no puede eliminar el seguidor de otro usuario' }, status: :forbidden if @seguidor.follower_id != @user.id && @user.role != 'moderador'

    if @seguidor.update(deleted: true)
      return render json: {message: "Eliminado con exito"}, status:200
    else
      return render json: {message: "Error al eliminar"}, status: :bad_request
    end
  end

  #Agregar paginacion a seguidores y seguidos

  def seguidores
    if params[:user_id].blank?
      return render json: {errors: "Debe pasar el user_id"}, status: 400
    end

    @seguidor = Seguidor.where(followed_id: params[:user_id], deleted: false).paginate(page: params[:page])
    ids = @seguidor.pluck(:follower_id)
    @users = User.where(id: ids)
    @users.map { |user| UserSerializer.new(user) }
    data = {
      total_pages: @seguidor.total_pages,
      last_page: params[:page] == @seguidor.total_pages,
      users:  @users.map { |user| UserSerializer.new(user) }
    }
    render json: data, status: 200
  end

  #No funciona
  def seguidos
    if params[:user_id].blank?
      return render json: {errors: "Debe pasar el user_id"}, status: 400
    end

    @seguidor = Seguidor.where(follower_id: params[:user_id], deleted: false).paginate(page: params[:page])
    ids = @seguidor.pluck(:followed_id)
    @users = User.where(id: ids)
    @users.map { |user| UserSerializer.new(user) }
    data = {
      total_pages: @seguidor.total_pages,
      last_page: params[:page] == @seguidor.total_pages,
      users:  @users.map { |user| UserSerializer.new(user) }
    }
    render json: data, status: 200
  end

  def cant_seguidores
    if params[:user_id].blank?
      return render json: {errors: "Debe pasar el user_id"}, status: 400
    end
    user_id = params[:user_id]
    seguidos = Seguidor.where(follower_id: user_id, deleted: false).count
    seguidores = Seguidor.where(followed_id: user_id, deleted: false).count

    return render json: {seguidos: seguidos, seguidores: seguidores}, status: 200
  end

  #Eliminar seguidor de un usuario
  def destroy_follower
    @user = get_user
    if @user.nil?
      render json: { error: "El usuario no se encuentra" }, status: 400
      return
    end
    @seguidor = Seguidor.find_by(followed_id: @user.id, follower_id: params[:id], deleted: false)
    return render json: { error: 'No se encuentra el seguimiento del usuario' }, status: :not_found if @seguidor.nil?
    return render json: { error: 'El usuario no puede eliminar el seguidor de otro usuario' }, status: :forbidden if @seguidor.followed_id != @user.id && @user.role != 'moderador'

    if @seguidor.update(deleted: true)
      return render json: {message: "Eliminado con exito"}, status:200
    else
      return render json: {message: "Error al eliminar"}, status: :bad_request
    end
  end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_seguidor
    @seguidor = Seguidor.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def seguidor_params
    params.permit( :follower_id, :followed_id)
  end
end
