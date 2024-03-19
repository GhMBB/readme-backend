class CapituloSerializer < ActiveModel::Serializer
  attributes :id, :indice, :titulo, :libro_id, :contenido, :next_capitulo_id, :previous_capitulo_id, :progreso, :publicado

  def next_capitulo_id
    next_capitulo = Capitulo.where(libro_id: object.libro_id, deleted: false, publicado: true)
                    .where("indice > ?", object.indice)
                    .order(indice: :asc).first
    next_capitulo.id if next_capitulo
  end

  def previous_capitulo_id
    previous_capitulo = Capitulo.where(libro_id: object.libro_id, deleted: false, publicado: true)
                        .where("indice < ?", object.indice)
                        .order(indice: :desc).first
    previous_capitulo.id if previous_capitulo
  end

  def progreso
    # Obtener todos los capítulos del libro actual que no han sido eliminados y están publicados
    capitulos_publicados = object.libro.capitulos.where(deleted: false, publicado: true)
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

end
