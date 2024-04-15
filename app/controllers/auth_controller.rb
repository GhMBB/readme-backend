# app/controllers/auth_controller.rb
class AuthController < ApplicationController
  #rescue_from StandardError, with: :internal_server_error
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
     UserMailer.with(user: @user).email_confirmation.deliver_later
     if @persona.nil?
       @persona = Persona.new(user_id: @user.id, fecha_de_nacimiento: params[:fecha_nacimiento], email_confirmed: true)
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

  def login_with_email
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      return render json: {error: "Usuario baneado"}, status: :forbidden if user.persona.baneado == true
      user.restablecer_cuenta(user, params) if user.persona.baneado != true  && !user.persona.fecha_eliminacion.nil? && user.persona.fecha_eliminacion > 30.days.ago
      token = JwtService.encode(user)
      expiration = JwtService.decode(token)['exp']
      profile = obtener_perfil(Persona.find_by(user_id: user.id).profile)
      return render json: {error: 'Falta confirmar el correo electronico', token: token, expiration: Time.at(expiration), username: user.username, role:user.role, user_id: user.id, profile: profile}, status: :forbidden if !user.blank? &&  user.persona.email_confirmed == false
      return render json: { token: token, expiration: Time.at(expiration), username: user.username, role:user.role, user_id: user.id, profile: profile}
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end
  def register_with_email
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
      UserMailer.with(user: @user).email_confirmation.deliver_later
      if @persona.nil?
        @persona = Persona.new(user_id: @user.id, fecha_de_nacimiento: params[:fecha_nacimiento])
        @persona.save
      end
      token = JwtService.encode(@user)
      expiration = JwtService.decode(token)['exp']
      render json: { message: "El codigo para la confirmacion de correo electronico le llegará en breve",
                     token: token, expiration: Time.at(expiration),
                     username: @user.username, role:@user.role, user_id:@user.id }
    else
      errors = @user.errors.full_messages
      render json: { error: errors }, status: :unprocessable_entity
    end
  end

  def email_confirmation
    authorization_header = request.headers["Authorization"]
    if authorization_header.nil?
      return render json: {error: "Debe proporcionar un token"}, status: :forbidden
    end
    token = authorization_header.split(" ").last
    decoded_token = JwtService.decode(token)
    user_id = decoded_token['user_id']
    user = User.find_by(id: user_id, deleted: false)
    if user.persona.confirmation_token == params[:email_confirmation_code]
      if user.persona.update(email_confirmed: true)
        #cambiar el codigo de confirmacion de correo
        user.persona.regenerate_confirmation_token!
        return render json: {message: 'Correo confirmado con exito'}, status: :ok
      else
        return render json: {error: 'Ha ocurrido un error al confirmar el codigo'}, status: :forbidden
      end
    else
      return render json: {error: 'El codigo de confirmacion es invalido'}, status: :forbidden
    end
  end

  def send_reset_password_email
    user = User.find_by(email: params[:email])
    if !user.blank?
      UserMailer.with(user: user).restore_password.deliver_later
      return render json: {error: 'Codigo de restauracion enviado'}, status: 200
    else
      return render json: {error: 'Usuario no encontrado'}, status: 400
    end
  end
  def reset_password
    user = User.find_by(reset_password_token:  params[:reset_password_code])
    if !user.blank?
      user.update(reset_params)
      user.regenerate_reset_password_token!
      return render json: {error: 'Contraseña actualizada con exito, inicie sesion nuevamente'}, status: 200
    else
      return render json: {error: 'Usuario no encontrado'}, status: 400
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
  def reset_params
    params.permit(  :password, :password_confirmation)
  end
  def user_params
    params.permit(:username, :email, :password, :password_confirmation, :role)
  end
end
