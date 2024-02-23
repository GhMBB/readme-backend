class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :password_digest, :role, :user_id
end
