class AddBaneadoToPersonas < ActiveRecord::Migration[7.1]
  def change
    add_column :personas, :baneado, :boolean
    add_column :personas, :fecha_eliminacion, :date
  end
end
