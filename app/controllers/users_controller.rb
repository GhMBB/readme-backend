class UsersController < ApplicationController
  before_action :authenticate_request
  before_action :set_user, only: %i[show destroy ]

  # GET /users/1
  def show
    @user.persona.profile = obtener_perfil(@user.persona.profile)
    render json: @user
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update_password
    @user = get_user
    if @user.nil?
      return render json: { error: 'No se ha encontrado al usuario' }, status: 400
    end

    if @user.authenticate(params[:current_password])
      if params[:new_password] == params[:confirm_password]
        if @user.update(password: params[:new_password])
          return render json:{message: 'Contraseña actualizada exitosamente'}, status: 200
        else
          return render json: @user.errors, status: :unprocessable_entity
        end
      else
        return render json: { error: 'Las contraseñas no coinciden' }, status: :unprocessable_entity
      end
    else
      return render json: { error: 'Contraseña actual incorrecta' }, status: :unprocessable_entity
    end
  end

  def update_username
    @user = get_user
    if @user.nil?
      return render json: { error: 'No se ha encontrado al usuario' }, status: 400
    end

    if @user.authenticate(params[:password])
      if @user.update(username: params[:username], password: params[:password])
        return render json: {message: "Username actualizado con exito", user: UserSerializer.new(@user)}, status: 200
      else
        return render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Contraseña incorrecta' }, status: :unprocessable_entity
    end
  end

  def update_profile
    @user = get_user
    if @user.nil?
      return render json: { error: 'No se ha encontrado al usuario' }, status: 400
    end

    @persona = @user.persona

    if @persona.nil?
      @persona = Persona.new(user_id: @user.id)
    end

    if params[:profile].present?
      @persona.profile = guardar_perfil
    else
      return render json: { error: 'Se debe pasar el perfil' }, status: 400
    end

    if @persona.save
      @persona.profile = obtener_perfil(@persona.profile)
      render json: @user, status: :ok
    else
      render json: @persona.errors, status: :unprocessable_entity
    end
  end



  # DELETE /users/1
  # Pasar la contraseña y verificar que sea el o un mod
  def destroy

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

  def guardar_perfil
    if params[:profile].present?
      cloudinary_response = Cloudinary::Uploader.upload(params[:profile], :folder => "fotosPerfil")

      if cloudinary_response['public_id'].present?
        return cloudinary_response['public_id']
      else
        render json: { error: 'No se pudo guardar la imagen.' }, status: :unprocessable_entity
        return
      end
    end
    return ""
  end

  def obtener_perfil(perfil_public_id)
    if !perfil_public_id
      return ""
    end

    begin
      enlace_temporal = Cloudinary::Utils.cloudinary_url("#{perfil_public_id}", :resource_type => :image, :expires_at => (Time.now + 3600).to_i)
      return enlace_temporal
    rescue CloudinaryException => e
      puts "Error al obtener la portada de Cloudinary: #{e.message}"
      return ""
    end
  end
    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :current_password , :new_password, :confirm_password, :profile)
    end
end
