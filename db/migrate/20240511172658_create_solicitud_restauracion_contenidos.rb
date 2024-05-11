class CreateSolicitudRestauracionContenidos < ActiveRecord::Migration[7.1]
  def change
    create_table :solicitud_restauracion_contenidos do |t|
      t.references :reportado, null: false, foreign_key: { to_table: :users }
      t.references :libro, foreign_key: true
      t.references :comentario, foreign_key: true
      t.string :estado
      t.string :justificacion
      t.boolean :deleted
      t.references :moderador, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
