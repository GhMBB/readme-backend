class ComentarioSerializer < ActiveModel::Serializer
  attributes :id, :comentario, :created_at, :username

  def username
    object.user.username if object.user
  end
end
