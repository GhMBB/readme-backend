class ReporteSerializer < ActiveModel::Serializer
  attributes :id, :libro_id, :created_at, :categoria, :estado, :motivo, :titulo_de_libro, :reportado_por, :conclusion

  def titulo_de_libro
    object.libro.present? ? object.libro.titulo : object.comentario.present? ? object.comentario.libro&.titulo : ''
  end

  def reportado_por
    object.user&.username
  end

  belongs_to :comentario
  belongs_to :usuario_reportado, class_name: 'User', serializer: UserSerializer
end
