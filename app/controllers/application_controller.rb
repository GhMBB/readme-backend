class ApplicationController < ActionController::API
  class << self
    def PAGE_SIZE
      2
    end
  end

  def decode_token
    authorization_header = request.headers["Authorization"]

    if authorization_header.nil?
      render json: {error: "Debe proporcionar un token"}, status: :forbidden
      return
    end

    token = authorization_header.split(" ").last

    begin
      decoded_token = JwtService.decode(token)

      if decoded_token && decoded_token.key?('user_id')
        user_id = decoded_token['user_id']
        user = User.find_by(id: user_id)

        if user
          return user
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

  def authorize_vendedor
    user = decode_token
    unless user.role == "vendedor"
      render json: {error: "Rol de vendedor Requerido"}, status: :forbidden
    end
  end

  def authorize_comprador
    user = decode_token
    unless user.role == "comprador"
      render json: {error: "Rol de comprador Requerido"}, status: :forbidden
    end
  end

end
