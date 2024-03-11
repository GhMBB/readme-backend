class RenamePreviousAndNextInCapitulos < ActiveRecord::Migration[7.1]
  def change
    rename_column :capitulos, :previous_capitulo, :previous_capitulo_id
    rename_column :capitulos, :next_capitulo, :next_capitulo_id
  end
end
