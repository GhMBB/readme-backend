require "jwt"
class JwtService
    def self.encode(user)
      payload = {
        user_id: user.id,
        username: user.username,
        role: user.role,
        exp: 1.hour.from_now.to_i  # Expire en 1 hora
      }
      JWT.encode(payload, Rails.application.config.secret_key, 'HS256')
    end

    def self.decode(token)
     JWT.decode(token, Rails.application.config.secret_key, true, algorithm: 'HS256')[0]
    end
  end
