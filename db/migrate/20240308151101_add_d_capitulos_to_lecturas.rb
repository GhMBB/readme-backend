class AddDCapitulosToLecturas < ActiveRecord::Migration[7.1]
  def change
    add_column :lecturas, :terminado, :boolean
    add_reference :lecturas, :capitulo, null: false, foreign_key: true
  end
end
