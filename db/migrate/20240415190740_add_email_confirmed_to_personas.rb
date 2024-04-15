class AddEmailConfirmedToPersonas < ActiveRecord::Migration[7.1]
  def change
    change_table :personas do |t|
      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email
    end
    add_column :personas, :email_confirmed, :boolean
  end
end
