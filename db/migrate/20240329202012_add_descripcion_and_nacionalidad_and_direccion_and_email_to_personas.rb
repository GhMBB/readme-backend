class AddDescripcionAndNacionalidadAndDireccionAndEmailToPersonas < ActiveRecord::Migration[7.1]
  def change
    add_column :personas, :descripcion, :string
    add_column :personas, :nacionalidad, :string
    add_column :personas, :direccion, :string
    add_column :personas, :email, :string
  end
end
