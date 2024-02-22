class Resenha < ApplicationRecord
  belongs_to :user
  belongs_to :libro

  validates :puntuacion, presence: { message: "La puntuación no puede estar vacía" }
  validates :puntuacion, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5, message: "La puntuación debe estar entre 0 y 5" }
end
