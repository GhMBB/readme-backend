class AddLeidoToLecturas < ActiveRecord::Migration[7.1]
  def change
    add_column :lecturas, :leido, :boolean
  end
end
