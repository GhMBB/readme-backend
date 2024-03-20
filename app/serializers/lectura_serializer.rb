class LecturaSerializer < ActiveModel::Serializer
  attributes :id, :libro_id, :user_id, :capitulo_id, :terminado

end
