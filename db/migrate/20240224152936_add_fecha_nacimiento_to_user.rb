class AddFechaNacimientoToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :fecha_nacimiento, :date
  end
end
