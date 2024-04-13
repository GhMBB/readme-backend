# app/controllers/auth_controller.rb
class AuthController < ApplicationController
  rescue_from StandardError, with: :internal_server_error
  def login
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      return render json: {error: "Usuario baneado"}, status: :forbidden if user.persona.baneado == true
      user.restablecer_cuenta(user, params) if user.persona.baneado != true  && !user.persona.fecha_eliminacion.nil? && user.persona.fecha_eliminacion > 30.days.ago
      token = JwtService.encode(user)
      expiration = JwtService.decode(token)['exp']
      profile = obtener_perfil(Persona.find_by(user_id: user.id).profile)
      render json: { token: token, expiration: Time.at(expiration), username: user.username, role:user.role, user_id: user.id, profile: profile}
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def register

   if params[:role] == "moderador"
     authorization_header = request.headers["Authorization"]
     if authorization_header.nil?
       return render json: {error: "Debe proporcionar un token"}, status: :forbidden
     end
     user = get_user
     return render json: { error: "Debes ser moderador para crear otro moderador"}, status: :unprocessable_entity if (user.role.blank? || user.role != "moderador")
   end
   @user = User.new(user_params)

    unless ["usuario","moderador"].include?(@user.role)
      render json: { error: "Solo se permiten los roles 'usuario' y 'moderador'"}, status: :unprocessable_entity
      return
    end

   if @user.save
     @persona = @user.persona
     if @persona.nil?
       @persona = Persona.new(user_id: @user.id, fecha_de_nacimiento: params[:fecha_nacimiento])
       @persona.save
     end
     token = JwtService.encode(@user)
     expiration = JwtService.decode(token)['exp']
     render json: { token: token, expiration: Time.at(expiration), username: @user.username, role:@user.role, user_id:@user.id }
   else
     errors = @user.errors.full_messages
     render json: { error: errors }, status: :unprocessable_entity
   end
  end

  private

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
  def user_params
    params.permit(:username, :password, :password_confirmation, :role)
  end
end
