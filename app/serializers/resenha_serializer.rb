class ResenhaSerializer < ActiveModel::Serializer
  attributes :id, :puntuacion, :user_id, :libro_id
  #has_one :user
  #has_one :libro
end
