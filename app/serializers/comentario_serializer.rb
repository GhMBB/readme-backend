class ComentarioSerializer < ActiveModel::Serializer
  attributes :id, :comentario
  #has_one :user
  #has_one :libro
end
