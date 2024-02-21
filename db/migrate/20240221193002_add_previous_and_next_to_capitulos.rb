class AddPreviousAndNextToCapitulos < ActiveRecord::Migration[7.1]
  def change
    add_column :capitulos, :previous_capitulo, :bigint
    add_column :capitulos, :next_capitulo, :bigint

add_foreign_key :capitulos, :capitulos, column: :previous_capitulo
add_foreign_key :capitulos, :capitulos, column: :next_capitulo
  end
end
