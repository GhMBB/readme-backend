class AddRoleChangeInfoToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :role_updated_at, :date
    add_reference :users, :role_updated_by, null: true, foreign_key: { to_table: :users }
  end
end
