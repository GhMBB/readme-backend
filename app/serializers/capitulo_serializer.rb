class CapituloSerializer < ActiveModel::Serializer
  attributes :id, :indice, :titulo, :libro_id, :contenido, :next_capitulo_id, :previous_capitulo_id
end
