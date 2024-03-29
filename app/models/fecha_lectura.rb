# frozen_string_literal: true
class FechaLectura  < ApplicationRecord
  belongs_to :lectura
  belongs_to :libro
  belongs_to :user

end
