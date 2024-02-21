class User < ApplicationRecord
   has_secure_password

    validates :username, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :role, inclusion: { in: %w(usuario moderador) }
end
