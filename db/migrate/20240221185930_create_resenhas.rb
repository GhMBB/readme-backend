class CreateResenhas < ActiveRecord::Migration[7.1]
  def change
    create_table :resenhas do |t|
      t.references :user, null: false, foreign_key: true
      t.references :libro, null: true, foreign_key: true
      t.integer :puntuacion

      t.timestamps
    end
  end
end
