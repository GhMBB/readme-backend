class AddRedesSocialesToPersona < ActiveRecord::Migration[7.1]
  def change
    add_column :personas, :redes_sociales, :text
  end
end
