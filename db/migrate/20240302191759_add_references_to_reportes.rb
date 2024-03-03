class AddReferencesToReportes < ActiveRecord::Migration[7.1]
  def change
    add_column :reportes, :categoria, :string
    add_reference :reportes, :comentario, null: true, foreign_key: true
    add_reference :reportes, :usuario_reportado, foreign_key: { to_table: :users }
  end
end
