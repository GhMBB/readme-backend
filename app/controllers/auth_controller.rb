# app/controllers/auth_controller.rb
class AuthController < ApplicationController
  #before_action :authenticate_request, only: [:register]

  def login
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      token = JwtService.encode(user)
      expiration = JwtService.decode(token)['exp']
      puts(expiration)
      render json: { token: token, expiration: Time.at(expiration), username: user.username, role:user.role }
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def register
    #authenticate_request # Requiere autenticación para registrar nuevos usuarios

    user = User.new(user_params)

    unless ["vendedor","comprador"].include?(user.role)
      render json: { error: "Solo se permiten los roles 'vendedor' y 'comprador'"}, status: :unprocessable_entity
      return
    end

    if user.save
      token = JwtService.encode(user)
      expiration = JwtService.decode(token)['exp']
      render json: { token: token, expiration: Time.at(expiration), username: user.username, role:user.role }
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:username, :password, :password_confirmation, :role)
  end
end
