class CreateFavoritos < ActiveRecord::Migration[7.1]
  def change
    create_table :favoritos do |t|
      t.references :user, null: false, foreign_key: true
      t.references :libro, null: false, foreign_key: true
      t.boolean :favorito

      t.timestamps
    end
  end
end
