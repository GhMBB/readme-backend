class AddFieldsToLibros < ActiveRecord::Migration[7.1]
  def change
    add_column :libros, :cantidad_lecturas, :integer
    add_column :libros, :cantidad_resenhas, :integer
  end
end
