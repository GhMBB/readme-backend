class RemoveProfileAndFechaNacimientoFromUsers < ActiveRecord::Migration[7.1]
=begin
  def change
    remove_column :users, :profile, :string
    remove_column :users, :fecha_nacimiento, :date
  end
=end
end
