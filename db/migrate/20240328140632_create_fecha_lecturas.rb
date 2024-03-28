class CreateFechaLecturas < ActiveRecord::Migration[7.1]
  def change
    create_table :fecha_lecturas do |t|
      t.references :lectura, null: false, foreign_key: true
      t.date :fecha

      t.timestamps
    end
  end
end
