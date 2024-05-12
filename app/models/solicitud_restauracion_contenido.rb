class SolicitudRestauracionContenido < ApplicationRecord
  belongs_to :reportado, class_name: "User"
  belongs_to :libro, optional: true
  belongs_to :comentario, optional: true
  belongs_to :moderador, optional: true, class_name: "User"

  validates :estado, inclusion: { in: %w(pendiente solicitado rechazado aceptado), 
         message: "El estado solo puede ser 'pendiente', 'solicitado' o 'rechazado'" 
        } 
attribute :deleted, :boolean, default: false

def self.create_solicitud_libro(usuario,params)
  libro = Libro.find_by(id: params[:libro_id])

  if libro.nil?
    return [{error: "Libro no encontrado"},404]
  end

  if libro.user_id != usuario.id
    return [{error: "Debes ser el dueño del libro"},401]
  end

  if !libro.deleted && !libro.deleted_by_user
    return [{error: "El libro no se encuentra baneado"},400]
  end

  solicitudes_existentes = SolicitudRestauracionContenido.where(libro_id: libro.id).order(created_at: :desc)
  if !solicitudes_existentes.empty?
    solicitud_existente = solicitudes_existentes.first
    if solicitud_existente.estado == "solicitado" || solicitud_existente.estado=="rechazado"
      return [{error: "Ya existe una solicitud pendiente o se ha rechazado la ultima solicitud"},400]
    end
  end

  begin
    solicitud = SolicitudRestauracionContenido.create(libro_id: libro.id, justificacion: params[:justificacion], reportado_id: usuario.id, estado: "solicitado")
    if solicitud.save!
      return [SolicitudRestauracionContenidoSerializer.new(solicitud), :ok]
    end
    return [{error: "Ha ocurrido un error en el servidor"}, 500]
  rescue => e
    puts "Error capturado: #{e.message}" # Imprime el mensaje de error
    return [{error:e}, 500]
  end
end

def self.create_solicitud_comentario(usuario,params)
  comentario = Comentario.find_by(id: params[:comentario_id])

  if comentario.nil?
    return [{error: "comentario no encontrado"},404]
  end

  if comentario.user_id != usuario.id
    return [{error: "Debes ser el dueño del comentario"},401]
  end

  if !comentario.deleted && !comentario.deleted_by_user
    return [{error: "El comentario no se encuentra baneado"},400]
  end

    solicitudes_existentes = SolicitudRestauracionContenido.where(comentario_id: comentario.id).order(created_at: :desc)
    if !solicitudes_existentes.empty?
      solicitud_existente = solicitudes_existentes.first
      if solicitud_existente.estado == "solicitado" || solicitud_existente.estado=="rechazado"
        return [{error: "Ya existe una solicitud pendiente o se ha rechazado la ultima solicitud"},400]
      end
    end

    begin
      solicitud = SolicitudRestauracionContenido.create(comentario_id: comentario.id, justificacion: params[:justificacion], reportado_id: usuario.id, estado: "solicitado")
      if solicitud.save!
        return [SolicitudRestauracionContenidoSerializer.new(solicitud), :ok]
      end
      return [{error: "Ha ocurrido un error en el servidor"}, 500]
    rescue => e
      puts "Error capturado: #{e.message}" # Imprime el mensaje de error
      return [{error:e}, 500]
    end
  end

  def self.aceptar_restauracion(solicitud_id, usuario)
    solicitud = SolicitudRestauracionContenido.find_by(id: solicitud_id)

    if solicitud.nil?
      return [{error: "No se ha encontrado la solicitud"},404]
    end

    if solicitud.estado == "aceptado"
      return [{error: "Ya se ha aceptado la solicitud"},400]
    end

    if !solicitud.libro_id.nil?
      libro = Libro.find_by(id: solicitud.libro_id)
      libro.update!(deleted:false) if !libro.nil?
    end

    if !solicitud.comentario_id.nil?
      comentario = Comentario.find_by(id: solicitud.comentario_id)
      comentario.update!(deleted: false) if !comentario.nil?
    end

    begin
      solicitud.update!(estado:"aceptado", moderador_id: usuario.id)
      return [SolicitudRestauracionContenidoSerializer.new(solicitud),:ok]
    rescue
      return [{error: "Ha ocurrido un error en el servidor"},500]
    end
  end

  def self.rechazar_restauracion(solicitud_id, usuario)
    solicitud = SolicitudRestauracionContenido.find_by(id: solicitud_id)

    if solicitud.nil?
      return [{error: "No se ha encontrado la solicitud"},404]
    end

    if solicitud.estado == "aceptado"
      return [{error: "Ya se ha aceptado la solicitud"},400]
    end

    if solicitud.estado == "rechazado"
      return [{error: "Ya se ha rechazado la solicitud"},400]
    end

    begin
      solicitud.update!(estado:"rechazado", moderador_id: usuario.id)
      return [SolicitudRestauracionContenidoSerializer.new(solicitud),:ok]
    rescue
      return [{error: "Ha ocurrido un error en el servidor"},500]
    end
  end

  def self.getPage(page,username,estado,fecha_desde,fecha_hasta)
    solicitudes = SolicitudRestauracionContenido.where(deleted: false)
    solicitudes = solicitudes.where.not(estado:"pendiente")
    solicitudes = solicitudes.where(estado: estado) if estado.present?
    solicitudes = solicitudes.where('solicitud_restauracion_contenidos.created_at >= ?', fecha_desde) if fecha_desde.present?
    solicitudes = solicitudes.where('solicitud_restauracion_contenidos.created_at <= ?', fecha_hasta) if fecha_hasta.present?
    solicitudes = solicitudes.joins(:reportado).where("users.username ILIKE ?", "%#{username}%") if username.present?

    

    solicitudes_paginadas = solicitudes.paginate(page: page.to_i)
    solicitudes_serializadas = solicitudes_paginadas.map do |solicitud|
      SolicitudRestauracionContenidoSerializer.new(solicitud)
    end
    total_pages = solicitudes_paginadas.total_pages
   return {
      total_pages: total_pages,
      last_page: page.to_i == total_pages, 
      solicitudes: solicitudes_serializadas
    }
  
  end

end
