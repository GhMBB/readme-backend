class SolicitudDesbaneoSerializer < ActiveModel::Serializer
  attributes :id, :justificacion, :estado, :nombre, :username,
             :cantidad_reportes, :created_at, :moderador_id, :moderador_username,
             :email, :conclusion

  def nombre
    object.baneado.persona.nombre rescue nil
  end

  def username
    object.baneado.username rescue nil
  end

  def email
    object.baneado.email rescue nil
  end

  def cantidad_reportes
    begin
      usuario_id = object.baneado.id
      reportes = Reporte.where(usuario_reportado_id: usuario_id)
      reportes.count
    rescue
      nil
    end
  end

  def moderador_username
    begin
      User.find_by(id: object.moderador_id).username
    rescue
      nil
    end
  end

  def conclusion
    begin
      usuario_id = object.baneado.id
      reportes = Reporte.where(usuario_reportado_id: usuario_id, estado: "resuelto")
                        .order(created_at: :desc)
      return reportes.first.conclusion unless reportes.empty?
      ""
    rescue
      nil
    end
  end
end
