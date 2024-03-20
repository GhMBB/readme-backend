class RemovePreviousCapituloIdAndRemoveNextCapituloId < ActiveRecord::Migration[7.1]
  def change
    remove_column :capitulos, :previous_capitulo_id
    remove_column :capitulos, :next_capitulo_id
  end
end
