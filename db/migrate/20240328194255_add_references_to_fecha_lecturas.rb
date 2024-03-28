class AddReferencesToFechaLecturas < ActiveRecord::Migration[7.1]
  def change
    add_reference :fecha_lecturas, :user, null: false, foreign_key: true
    add_reference :fecha_lecturas, :libro, null: false, foreign_key: true
  end
end
