class AddVisibilityAttributesToPersona < ActiveRecord::Migration[7.1]
  def change
    add_column :personas, :mostrar_seguidos, :boolean
    add_column :personas, :mostrar_seguidores, :boolean
    add_column :personas, :mostrar_lecturas, :boolean
    add_column :personas, :mostrar_datos_personales, :boolean
  end
end
