class ResenhaSerializer < ActiveModel::Serializer
  attributes :id, :puntuacion
  has_one :user
  has_one :libro
end
