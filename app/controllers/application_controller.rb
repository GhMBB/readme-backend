class ApplicationController < ActionController::API

  def get_user
    user = decode_token
    return user
  end
  def decode_token
    authorization_header = request.headers["Authorization"]

    if authorization_header.nil?
      return render json: {error: "Debe proporcionar un token"}, status: :forbidden
    end

    token = authorization_header.split(" ").last

    begin
      decoded_token = JwtService.decode(token)

      if decoded_token && decoded_token.key?('user_id')
        user_id = decoded_token['user_id']
        user = User.find_by(id: user_id)

        if user
          return user
        else
          render json: {error: "Usuario no encontrado, token invalido"}, status: :forbidden
          return nil
        end
      end
    rescue JWT::ExpiredSignature
      render json: {error: "Token expirado"}, status: :forbidden
      return nil
    rescue JWT::DecodeError
      render json: {error: "Token Invalido"}, status: :forbidden
      return
    end
  end


  def authenticate_request
    decode_token
  end

  def authorize_usuario
    user = decode_token
    unless user.role == "usuario"
      render json: {error: "Rol de usuario Requerido"}, status: :forbidden
    end
  end

  def authorize_moderador
    user = decode_token
    unless user.role == "moderador"
      render json: {error: "Rol de moderador Requerido"}, status: :forbidden
    end
  end

  def internal_server_error
    render json: {error: "Ha ocurrido un error en el servidor."}, status: 500
    return
  end

end
