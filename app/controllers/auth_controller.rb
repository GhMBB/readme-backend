# app/controllers/auth_controller.rb
class AuthController < ApplicationController

  def login
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      token = JwtService.encode(user)
      expiration = JwtService.decode(token)['exp']
      puts(expiration)
      render json: { token: token, expiration: Time.at(expiration), username: user.username, role:user.role, user_id: user.id }
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def register
  ActiveRecord::Base.transaction do
    user = User.new(user_params)

    unless ["usuario", "moderador"].include?(user.role)
      render json: { error: "Solo se permiten los roles 'usuario' y 'moderador'"}, status: :unprocessable_entity
      return
    end

    if user.save
      if user.role == "moderador"
        token = params[:token]
        unless token.present? && JwtService.decode(token)['role'] == 'moderador'
          render json: { error: "Se requiere un usuario moderador válido"}, status: :unprocessable_entity
          raise ActiveRecord::Rollback  # Rollback en caso de error
        end
      else
        token = JwtService.encode(user)
      end

      expiration = JwtService.decode(token)['exp']
      render json: { token: token, expiration: Time.at(expiration), username: user.username, role:user.role, user_id:user.id, fecha_nacimiento: user.fecha_nacimiento }
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
rescue ActiveRecord::Rollback
  render json: { error: "Error al procesar la transacción. Se ha realizado un rollback." }, status: :unprocessable_entity
end


  private

  def user_params
    params.permit(:username, :password, :password_confirmation, :role, :fecha_nacimiento)
  end
end
