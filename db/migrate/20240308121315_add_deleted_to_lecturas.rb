class AddDeletedToLecturas < ActiveRecord::Migration[7.1]
  def change
    add_column :lecturas, :deleted, :boolean
  end
end
