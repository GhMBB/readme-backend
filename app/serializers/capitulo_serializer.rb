class CapituloSerializer < ActiveModel::Serializer
  attributes :id, :titulo, :nombre_archivo
  has_one :libro
end
