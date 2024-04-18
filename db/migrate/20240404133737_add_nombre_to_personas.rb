class AddNombreToPersonas < ActiveRecord::Migration[7.1]
  def change
    add_column :personas, :nombre, :string
  end
end
