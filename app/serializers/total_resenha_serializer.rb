class TotalResenhaSerializer < ActiveModel::Serializer
  attributes :id, :cantidad, :sumatoria, :media
  has_one :libro
end
