class SolicitudDesbaneo < ApplicationRecord
  belongs_to :baneado, class_name: "User"
  
  # Validaciones
  validates :estado, inclusion: { in: %w(pendiente solicitado rechazado aceptado), 
                                  message: "El estado solo puede ser 'pendiente', 'solicitado' o 'rechazado'" 
                                }
  attribute :deleted, :boolean, default: false

  def self.create_solicitud(email, justificacion)
    usuario_baneado = User.find_by(email: email)
    persona = usuario_baneado.persona
  
    if usuario_baneado.nil?
      return [{ error: 'Usuario no encontrado' }, :unprocessable_entity]
    end

    if !persona.baneado
      return [{ error: 'El usuario no ha sido baneado' }, :unprocessable_entity]
    end

    #Obtener la ultima solicitud generada
    solicitud = SolicitudDesbaneo.where(baneado_id: usuario_baneado.id, deleted: false).order(created_at: :desc).first    
    if solicitud.estado != "pendiente"
        return [{ error: 'Ya se ha realizado una solicitud de desbaneo' }, :unprocessable_entity]
    end

    solicitud.estado="solicitado"
    solicitud.justificacion = justificacion
    if solicitud.save
      return [solicitud , :ok]
    end
    return [{ error: 'No se ha podido crear la solicitud' }, :unprocessable_entity]

  end

  def self.aceptar_desbaneo(solicitud_id, moderador)
    solicitud = SolicitudDesbaneo.find_by(id: solicitud_id, deleted:false)

    if solicitud.nil?
      return [{ error: 'Solicitud no encontrada' }, :unprocessable_entity]
    end

    if solicitud.estado == "aceptado"
      return [{ error: 'La solicitud ya ha sido aceptada' }, :unprocessable_entity]
    end

    usuario_baneado = solicitud.baneado
    persona = usuario_baneado.persona

    begin
      ActiveRecord::Base.transaction do
        solicitud.update!(estado: "aceptado")
        usuario_baneado.update_columns(deleted: false)
        persona.update!(baneado: false)
        NotificationMailer.with(user: usuario_baneado).desban_notification.deliver_later
        return [ solicitud , :ok]
      end
    rescue StandardError => e
      return [{ error: 'No se ha podido procesar la solicitud' }, :unprocessable_entity]
    end
  end

  def self.rechazar_desbaneo(solicitud_id, moderador)
    solicitud = SolicitudDesbaneo.find_by(id: solicitud_id,deleted:false)

    if solicitud.nil?
      return [{ error: 'Solicitud no encontrada' }, :unprocessable_entity]
    end

    if solicitud.estado == "rechazado"
      return [{ error: 'La solicitud ya ha sido rechazada' }, :unprocessable_entity]
    end

    if solicitud.estado == "aceptado"
      return [{ error: 'La solicitud ya ha sido aceptada' }, :unprocessable_entity]
    end

    begin
      ActiveRecord::Base.transaction do
        solicitud.update!(estado:"rechazado")
        NotificationMailer.with(user: solicitud.baneado).desban_rejected_notification.deliver_later

        return ["" , :ok]
      end
    rescue StandardError => e
      return [{ error: 'No se ha podido rechazar la solicitud' }, :unprocessable_entity]
    end
  end

  def self.getPage(page,username,estado,fecha_desde,fecha_hasta)
    solicitudes = SolicitudDesbaneo.where(deleted: false)
    solicitudes = solicitudes.where(estado: estado) if estado.present?
    solicitudes = solicitudes.where('solicitud_desbaneos.created_at >= ?', fecha_desde) if fecha_desde.present?
    solicitudes = solicitudes.where('solicitud_desbaneos.created_at <= ?', fecha_hasta) if fecha_hasta.present?
    solicitudes = solicitudes.joins(:baneado).where("users.username ILIKE ?", "%#{username}%") if username.present?

    

    solicitudes_paginadas = solicitudes.paginate(page: page.to_i)
    solicitudes_serializadas = solicitudes_paginadas.map do |solicitud|
      SolicitudDesbaneoSerializer.new(solicitud)
    end
    total_pages = solicitudes_paginadas.total_pages
   return {
      total_pages: total_pages,
      last_page: page.to_i == total_pages, 
      solicitudes_desbaneo: solicitudes_serializadas
    }
  
  end


end
