class CreateCapitulos < ActiveRecord::Migration[7.1]
  def change
    create_table :capitulos do |t|
      t.references :libro, null: false, foreign_key: true
      t.string :titulo
      t.string :nombre_archivo

      t.timestamps
    end
  end
end
