# frozen_string_literal: true

class Reporte < ApplicationRecord
  belongs_to :user
  belongs_to :libro, optional: true
  belongs_to :comentario, optional: true
  belongs_to :usuario_reportado, class_name: 'User', optional: true
  belongs_to :moderador, class_name: 'User', optional: true

  validates :user_id, presence: { message: 'El ID de usuario no puede estar en blanco' }
  validates :motivo, presence: { message: 'El motivo no puede estar en blanco' }
  validates :estado, presence: { message: 'El estado no puede estar en blanco' }

  attribute :deleted, :boolean, default: false
  # validates :estado, inclusion:  { in: ->(e) { e.class.estado.keys }, message: "El estado seleccionado no es válido" }

  enum estado: {
    pendiente: 'pendiente', # Cuando se crea el reporte
    en_revision: 'en_revision', # Cuando un usuario moderador está evaluando el reporte
    aceptado: 'aceptado', # Si el reporte fue aceptado
    rechazado: 'rechazado', # Si el moderador rechaza el reporte
    resuelto: 'resuelto' # Una vez que se ha tomado alguna acción sobre el reporte, como la eliminacion del contenido reportado.
  }
  def self.create_reporte(tipo, tipo_id, reporte_params, user)
    case tipo
    when 'libro'
      recurso = Libro.find_by(id: tipo_id)
    when 'comentario'
      recurso = Comentario.find_by(id: tipo_id)
    when 'usuario'
      recurso = User.find_by(id: tipo_id)
    else
      return { error: 'Tipo de recurso inválido' }, :bad_request
    end

    return { error: 'El recurso no fue encontrado' }, :not_found if recurso.nil?

    reporte = recurso.reportes.new(reporte_params)
    reporte.user_id = user.id
    return { message: 'Reporte creado exitosamente', reporte: reporte}, :ok if reporte.save

    [{ errors: reporte.errors.full_messages }, :unprocessable_entity]
  end

  def update_reporte(reporte_params, user)
    if user.role != 'moderador' || user.role != 'administrador'
      return [{ error: 'Debes ser moderador para actualizar los reportes' }, :unprocessable_entity]
    end
    if self.nil?
      [{ error: 'Reporte no encontrado' }, :not_found]
    else
      self.update(reporte_params.merge(moderador_id: user.id))
      [{ message: 'Reporte actualizado exitosamente', reporte: self }, :ok]
    end
  end

  def destroy_reporte(user)
    if user.role != 'administrador'
      return { error: 'Debes ser administrador para eliminar los reportes' }, :unprocessable_entity
    end
    return { error: 'Reporte no encontrado' }, :not_found if nil?

    update(deleted: true, moderador_id: user.id)
    [{ message: 'Reporte eliminado exitosamente' }, :ok]
  end

  def self.actualizar_muchos_reportes(tipo, tipo_id, estado, nuevo_estado, conclusion, mod_id)
    case tipo
    when 'libro'
      reportes = Reporte.where(libro_id: tipo_id, estado: estado, deleted: false)
    when 'comentario'
      reportes = Reporte.where(comentario_id: tipo_id, estado: estado, deleted: false)
    when 'usuario'
      reportes = Reporte.where(usuario_reportado_id: tipo_id, estado: estado, deleted: false)
    else
      return { error: 'Tipo de recurso inválido' }, :bad_request
    end
  
    return [{error: 'El reporte no fue encontrado'}, 404] if reportes.blank?
  
    reportes.update_all(estado: nuevo_estado, conclusion: conclusion, moderador_id: mod_id)
    [{ message: 'El estado de los reportes se ha actualizado correctamente' }, :ok]
  end

  def self.getAllByUserId(id,params)
    usuario = User.find_by(id: id)
    if usuario.nil?
      return [{error: 'Usuario no encontrado'}, 404]
    end

    begin
      query = Reporte.where(deleted: false, user_id: id, estado: "resuelto")
      query = Reporte.where(deleted: false, estado: "resuelto")

      query = case params[:tipo]
      when 'libro'
        query.joins("LEFT JOIN libros ON reportes.libro_id = libros.id")
                     .where("libros.user_id = ?", id)
      when 'comentario'
        query.joins("LEFT JOIN comentarios ON reportes.comentario_id = comentarios.id")
                     .where("comentarios.user_id = ?", id)
      else
        query.joins("LEFT JOIN libros ON reportes.libro_id = libros.id")
                       .joins("LEFT JOIN comentarios ON reportes.comentario_id = comentarios.id")
                       .where("libros.user_id = ? OR comentarios.user_id = ?", id, id)
              end
      paginated_query = query.paginate(page: params[:page], per_page: WillPaginate.per_page)

      data = {
        total_pages: paginated_query.total_pages,
        total_items: query.count,
        data: paginated_query.map do |reporte|
          # Verificar si existe una solicitud de desbaneo para el libro o comentario
          solicitud_desbaneo = SolicitudRestauracionContenido.where(
            "(reportado_id = ? AND libro_id = ?) OR (reportado_id = ? AND comentario_id = ?)",
            id, reporte.libro_id, id, reporte.comentario_id
          ).exists?
          ReporteSerializer.new(reporte).as_json.merge(solicitud_desbaneo: solicitud_desbaneo)
        end
      }
      return data, 200
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace
      return { error: e.message }, 500
    end
    
  end

  
  def self.find_by_params(params)
    query = all
    query = query.where(deleted: false)
    query = query.where(estado: params[:estado]) if params[:estado].present?
    query = query.where(motivo: params[:motivo]) if params[:motivo].present?
    query = query.where(categoria: params[:categoria]) if params[:categoria].present?
    query = query.where(libro_id: params[:libro_id]) if params[:libro_id].present?
    query = query.where(comentario_id: params[:comentario_id]) if params[:comentario_id].present?
    query = query.where(usuario_reportado_id: params[:usuario_reportado_id]) if params[:usuario_reportado_id].present?

    paginated_query = query.paginate(page: params[:page], per_page: WillPaginate.per_page)
    data = {
      total_pages: paginated_query.total_pages,
      total_items: query.count,
      data: ActiveModel::Serializer::CollectionSerializer.new(paginated_query, serializer: ReporteSerializer)
    }
    return data, 200
  end

  def self.find_with_counts(params)
    query = self.select(:libro_id, :comentario_id, :usuario_reportado_id, 'COUNT(*) as total_reportes')
        .where(deleted: false)
        .group(:libro_id, :comentario_id, :usuario_reportado_id)

    paginated_query = query.paginate(page: params[:page], per_page: WillPaginate.per_page)
    data = {
      total_pages: paginated_query.total_pages,
      data: paginated_query
    }
    return data, 200
  end
end
