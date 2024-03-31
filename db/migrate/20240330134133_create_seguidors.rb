class CreateSeguidors < ActiveRecord::Migration[7.1]
  def change
    create_table :seguidors do |t|

      t.timestamps
    end
  end
end
