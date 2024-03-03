class Comentario < ApplicationRecord
  belongs_to :user
  belongs_to :libro

  has_many :reportes, -> { where(deleted: false) }, foreign_key: :comentario_id
end
