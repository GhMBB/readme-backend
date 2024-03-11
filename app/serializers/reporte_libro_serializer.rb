# frozen_string_literal: true

class ReporteLibroSerializer  < ActiveModel::Serializer
  attributes :id,:user_id, :libro_id, :estado, :motivo, :categoria ,:conclusion, :moderador_id
end
