class AddUserReferencesToSeguidores < ActiveRecord::Migration[7.1]
  def change
    add_reference :seguidors, :follower,  foreign_key:  { to_table: :users }
    add_reference :seguidors, :followed, foreign_key:  { to_table: :users }
  end
end
