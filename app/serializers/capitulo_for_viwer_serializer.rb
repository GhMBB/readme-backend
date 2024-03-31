class CapituloForViwerSerializer < ActiveModel::Serializer
  attributes :id, :indice, :titulo, :libro_id, :contenido, :next_capitulo_id, :previous_capitulo_id, :publicado, :progreso, :updated_at

  def next_capitulo_id
    next_capitulo = Capitulo.where(libro_id: object.libro_id, publicado: true, deleted: false)
                            .where("indice > ?", object.indice)
                            .order(indice: :asc).first
    next_capitulo.id if next_capitulo
  end

  def previous_capitulo_id
    previous_capitulo = Capitulo.where(libro_id: object.libro_id, publicado: true, deleted: false)
                                .where("indice < ?", object.indice)
                                .order(indice: :desc).first
    previous_capitulo.id if previous_capitulo
  end

  def progreso
    # Obtener todos los capítulos del libro actual que no han sido eliminados y están publicados
    capitulos_publicados = object.libro.capitulos.where(publicado: true, deleted: false)
    # Contar cuántos capítulos tienen un índice menor al del capítulo actual
    capitulos_anteriores = capitulos_publicados.where('indice < ?', object.indice).count
    # Calcular el progreso dividiendo el número de capítulos anteriores por el total de capítulos
    if capitulos_publicados.count > 0
      progreso = capitulos_anteriores.to_f / capitulos_publicados.count
    else
      progreso = 0.0 # Si no hay capítulos publicados, el progreso es 0
    end
    progreso
  end

  def contenido
    obtener_contenido(object.nombre_archivo)
  end
  def obtener_contenido(contenido_public_id)
    if !contenido_public_id
      return ""
    end

    begin
      enlace_temporal = Cloudinary::Utils.cloudinary_url("#{contenido_public_id}", :resource_type => :raw, :expires_at => (Time.now + 3600).to_i)
      return enlace_temporal
    rescue CloudinaryException => e
      return ""
    end
  end
end
