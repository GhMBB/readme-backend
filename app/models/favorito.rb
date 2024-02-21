class Favorito < ApplicationRecord
  belongs_to :user
  belongs_to :libro
end
