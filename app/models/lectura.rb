class Lectura < ApplicationRecord
  belongs_to :user
  belongs_to :libro
  belongs_to :capitulo
end
