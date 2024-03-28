class UsersController < ApplicationController
  before_action :authenticate_request
  before_action :set_user, only: %i[show ]

  rescue_from StandardError, with: :internal_server_error

  # GET /users/1
  def show
    render json: @user
  end

  def update_password
    @user = get_user
    if @user.nil?
      return render json: { error: 'No se ha encontrado al usuario' }, status: 400
    end
    message, status = @user.update_password(params, @user)
    return render json: message , status: status
  end

  def update_username
    @user = get_user
    if @user.nil?
      return render json: { error: 'No se ha encontrado al usuario' }, status: 400
    end
    message, status = @user.update_username(params, @user)
    return render json: message , status: status
  end

  def update_profile
    @user = get_user
    if @user.nil?
      return render json: { error: 'No se ha encontrado al usuario' }, status: 400
    end
    message, status = @user.update_profile(params, @user)
    return render json: message, status: status
  end
  def destroy_profile
    @user = get_user
    if @user.nil?
      return render json: { error: 'No se ha encontrado al usuario' }, status: 400
    end
    message, status = @user.delete_profile(@user)
    return render json: message, status: status
  end


  # GET /users/byUsername
  def get_userByUsername
    @user = User.find_by(username: params[:username], deleted: false)
    if @user
      render json:@user, status: :ok
    else
      render json: {error: "usuario con no encontrado"}, status: :unprocessable_entity
    end
  end
  def update_birthday
    @user = get_user
    if @user.nil?
      return render json: { error: 'No se ha encontrado al usuario' }, status: 400
    end
    message, status = @user.update_birthday(params, @user)
    return render json: message, status: status
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :current_password , :new_password, :confirm_password, :profile, :fecha_de_nacimiento)
    end
end
