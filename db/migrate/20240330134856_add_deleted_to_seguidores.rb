class AddDeletedToSeguidores < ActiveRecord::Migration[7.1]
  def change
    add_column :seguidors, :deleted, :boolean
  end
end
