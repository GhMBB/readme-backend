class LecturaSerializer < ActiveModel::Serializer
  attributes :id, :fecha
  has_one :user
  has_one :libro
end
