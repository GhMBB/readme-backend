# frozen_string_literal: true

class ReporteUserSerializer  < ActiveModel::Serializer
  attributes :id,:user_id, :estado, :motivo, :categoria, :usuario_reportado_id, :conclusion, :moderador_id
end
