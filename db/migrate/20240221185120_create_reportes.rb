class CreateReportes < ActiveRecord::Migration[7.1]
  def change
    create_table :reportes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :libro, null: false, foreign_key: true
      t.string :motivo
      t.string :estado

      t.timestamps
    end
  end
end
