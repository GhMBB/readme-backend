class SolicitudDesbaneo < ApplicationRecord
  belongs_to :baneado, class_name: "User"
  
  # Validaciones
  validates :estado, inclusion: { in: %w(pendiente solicitado rechazado), 
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

    solicitud_existente = SolicitudDesbaneo.find_by(baneado_id: usuario_baneado.id, deleted: false)
    if !solicitud_existente.nil?
      return [{ error: 'Ya se ha realizado una solicitud de desbaneo' }, :unprocessable_entity]
    end


    solicitud = SolicitudDesbaneo.new(justificacion: justificacion, estado: 'solicitado')
    solicitud.baneado = usuario_baneado

    if solicitud.save
      return [ solicitud , :ok]
    end
    return [{ error: 'No se ha podido crear la solicitud' }, :unprocessable_entity]

  end

  def self.aceptar_desbaneo(solicitud_id)
    solicitud = SolicitudDesbaneo.find_by(id: solicitud_id, deleted:false)

    if solicitud.nil?
      return [{ error: 'Solicitud no encontrada' }, :unprocessable_entity]
    end

    usuario_baneado = solicitud.baneado
    persona = usuario_baneado.persona

    begin
      ActiveRecord::Base.transaction do
        solicitud.update!(deleted: true)
        usuario_baneado.update_columns(deleted: false)
        persona.update!(baneado: false)
        return [ solicitud , :ok]
      end
    rescue StandardError => e
      return [{ error: 'No se ha podido procesar la solicitud' }, :unprocessable_entity]
    end
  end

  def self.rechazar_desbaneo(solicitud_id)
    solicitud = SolicitudDesbaneo.find_by(id: solicitud_id,deleted:false)

    if solicitud.nil?
      return [{ error: 'Solicitud no encontrada' }, :unprocessable_entity]
    end
    begin
      ActiveRecord::Base.transaction do
        solicitud.update!(estado:"rechazado")
        return [nil, :ok]
      end
    rescue StandardError => e
      return [{ error: 'No se ha podido rechazar la solicitud' }, :unprocessable_entity]
    end
  end


end
