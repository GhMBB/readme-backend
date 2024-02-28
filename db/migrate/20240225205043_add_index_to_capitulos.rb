class AddIndexToCapitulos < ActiveRecord::Migration[7.1]
  def change
    add_column :capitulos, :indice, :integer
  end
end
