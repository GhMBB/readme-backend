class SolicitudDesbaneoSerializer < ActiveModel::Serializer
  attributes :id, :justificacion, :estado, :nombre, :username, :cantidad_reportes, :created_at, :moderador_id

  def nombre
    object.baneado.persona.nombre
  end

  def username
    object.baneado.username
  end

  def cantidad_reportes
    usuario_id = object.baneado.id
    reportes = Reporte.where(usuario_reportado_id: usuario_id)
    reportes.count
  end

end
