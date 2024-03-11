# frozen_string_literal: true

class ReporteComentarioSerializer < ActiveModel::Serializer
  attributes :id,:user_id, :comentario_id, :estado, :motivo, :categoria,:conclusion, :moderador_id
end
