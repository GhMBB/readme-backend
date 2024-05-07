class SolicitudDesbaneoSerializer < ActiveModel::Serializer
  attributes :id, :justificacion, :estado
  has_one :baneado
end
