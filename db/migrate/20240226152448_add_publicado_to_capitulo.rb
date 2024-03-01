class AddPublicadoToCapitulo < ActiveRecord::Migration[7.1]
  def change
    add_column :capitulos, :publicado, :boolean
  end
end
