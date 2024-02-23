class AddSumatoriaToLibros < ActiveRecord::Migration[7.1]
  def change
    add_column :libros, :sumatoria, :integer
  end
end
