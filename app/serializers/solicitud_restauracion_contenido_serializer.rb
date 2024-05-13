class SolicitudRestauracionContenidoSerializer < ActiveModel::Serializer
  attributes :id, :justificacion, :libro_id , :comentario_id, :estado, :username,
             :cantidad_reportes, :created_at, :baneado_por, :fecha_de_baneo,
             :libro, :conclusion, :tipo, :comentario, :motivo


  def username
    object.reportado.username rescue nil
  end


  def cantidad_reportes
    begin
      if !object.libro_id.nil?
        return  Reporte.where(libro_id: object.libro_id).count
      end
      if !object.comentario_id.nil?
        return  Reporte.where(comentario_id: object.comentario_id).count
      end
      return 0
    rescue
      nil
    end
  end

  def baneado_por
    begin
      if !object.libro_id.nil?
        mod_id = Reporte.where(libro_id: object.libro_id,estado:"resuelto").order(created_at: :desc).first.moderador_id
        return User.find_by(id:mod_id).username
      end
      if !object.comentario_id.nil?
        mod_id = Reporte.where(comentario_id: object.comentario_id,estado:"resuelto").order(created_at: :desc).first.moderador_id
        return User.find_by(id:mod_id).username
      end
      return nil
    rescue
      nil
    end
  end

  def fecha_de_baneo
    begin
      if !object.libro_id.nil?
       return Reporte.where(libro_id: object.libro_id,estado:"resuelto").order(created_at: :desc).first.created_at
      end
      if !object.comentario_id.nil?
        return Reporte.where(comentario_id: object.comentario_id,estado:"resuelto").order(created_at: :desc).first.created_at
      end
      return nil
    rescue
      nil
    end
  end

  def libro
    begin
      if !object.libro_id.nil?
        return Libro.find_by(id: object.libro_id).titulo
      end
      if !object.comentario_id.nil?
        libro_id = Comentario.find_by(id: object.comentario_id).libro_id
        return Libro.find_by(id: libro_id).titulo
      end
    rescue
      nil
    end
  end

  def tipo
    begin
      if !object.libro_id.nil?
        return "Libro"
      end
      if !object.comentario_id.nil?
        return "Comentario"
      end
      "No identificable"
    rescue
      "No identificable"
    end
  end

  def comentario
    begin
      if !object.comentario_id.nil?
       return Comentario.find_by(id: object.comentario_id).comentario
      end
      nil
    rescue
      nil
    end
  end

  def motivo
    begin
      if !object.libro_id.nil?
       return Reporte.where(libro_id: object.libro_id,estado:"resuelto").order(created_at: :desc).first.motivo
      end
      if !object.comentario_id.nil?
        return Reporte.where(comentario_id: object.comentario_id,estado:"resuelto").order(created_at: :desc).first.motivo
      end
      return nil
    rescue
      nil
    end
  end

  def conclusion
    begin
      if !object.libro_id.nil?
       return Reporte.where(libro_id: object.libro_id,estado:"resuelto").order(created_at: :desc).first.conclusion
      end
      if !object.comentario_id.nil?
        return Reporte.where(comentario_id: object.comentario_id,estado:"resuelto").order(created_at: :desc).first.conclusion
      end
      return nil
    rescue
      nil
    end
  end
end
