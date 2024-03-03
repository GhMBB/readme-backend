class ReporteSerializer < ActiveModel::Serializer
  attributes :libro_id, :comentario_id, :usuario_reportado_id, :total_reportes
  #has_one :libro
end
