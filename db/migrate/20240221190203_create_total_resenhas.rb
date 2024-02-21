class CreateTotalResenhas < ActiveRecord::Migration[7.1]
  def change
    create_table :total_resenhas do |t|
      t.references :libro, null: false, foreign_key: true
      t.integer :cantidad
      t.integer :sumatoria
      t.float :media

      t.timestamps
    end
  end
end
