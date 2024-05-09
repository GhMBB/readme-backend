class SolicitudDesbaneoSerializer < ActiveModel::Serializer
  attributes :id, :justificacion, :estado, :nombre, :username,
   :cantidad_reportes, :created_at, :moderador_id, :moderador_username,
   :email, :conclusion

  def nombre
    object.baneado.persona.nombre
  end

  def username
    object.baneado.username
  end

  def email
    object.baneado.email
  end

  def cantidad_reportes
    usuario_id = object.baneado.id
    reportes = Reporte.where(usuario_reportado_id: usuario_id)
    reportes.count
  end

  def moderador_username
    User.find_by(id: object.moderador_id).username
  end

  def conclusion
    usuario_id = object.baneado.id
    reportes = Reporte.where(usuario_reportado_id: usuario_id,estado:"resuelto")
    .order(created_at: :desc)
    if reportes.nil?
      return ""
    end
    return reportes.first.conclusion
  end

end
