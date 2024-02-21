class CreateUser < ActiveRecord::Migration[7.1]
 def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :role

      t.timestamps
    end
  end
end
