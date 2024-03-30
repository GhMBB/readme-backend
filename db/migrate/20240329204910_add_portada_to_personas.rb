class AddPortadaToPersonas < ActiveRecord::Migration[7.1]
  def change
    add_column :personas, :portada, :string
  end
end
