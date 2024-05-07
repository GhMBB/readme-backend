class CreateSolicitudDesbaneos < ActiveRecord::Migration[7.1]
  def change
    create_table :solicitud_desbaneos do |t|
      t.references :baneado, null: false, foreign_key: { to_table: :users }
      t.string :justificacion
      t.string :estado

      t.timestamps
    end
  end
end
