class AddCategoriaToLibros < ActiveRecord::Migration[7.1]
  def change
    add_column :libros, :categoria, :string
  end
end
