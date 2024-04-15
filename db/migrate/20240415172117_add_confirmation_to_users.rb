class AddConfirmationToUsers < ActiveRecord::Migration[7.1]
  def change

    change_table :users do |t|
      t.string :email
      ## Confirmable
=begin
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable
=end

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
    end
=begin
    add_index :users, :email,                unique: true
    add_index :users, :confirmation_token,   unique: true
    add_index :users, :reset_password_token, unique: true
=end

  end
end
