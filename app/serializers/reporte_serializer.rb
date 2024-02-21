class ReporteSerializer < ActiveModel::Serializer
  attributes :id, :motivo, :estado
  has_one :user
  has_one :libro
end
