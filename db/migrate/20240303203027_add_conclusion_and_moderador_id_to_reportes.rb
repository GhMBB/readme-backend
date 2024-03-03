class AddConclusionAndModeradorIdToReportes < ActiveRecord::Migration[7.1]
  def change
    add_column :reportes, :conclusion, :text
    add_reference :reportes, :moderador, foreign_key: { to_table: :users }
  end
end
