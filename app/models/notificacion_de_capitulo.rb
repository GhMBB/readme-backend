class NotificacionDeCapitulo < ApplicationRecord
  belongs_to :user
  belongs_to :libro
  attribute :deleted, :boolean, default: false
end
