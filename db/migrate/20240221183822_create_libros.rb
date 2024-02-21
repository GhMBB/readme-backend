class CreateLibros < ActiveRecord::Migration[7.1]
  def change
    create_table :libros do |t|
      t.string :titulo
      t.text :sinopsis
      t.string :portada
      t.boolean :adulto
      t.float :puntuacion_media
      t.integer :cantidad_comentarios
      t.string :portada_url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
