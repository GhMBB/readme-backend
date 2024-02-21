class CreateComentarios < ActiveRecord::Migration[7.1]
  def change
    create_table :comentarios do |t|
      t.references :user, null: false, foreign_key: true
      t.references :libro, null: false, foreign_key: true
      t.text :comentario

      t.timestamps
    end
  end
end
