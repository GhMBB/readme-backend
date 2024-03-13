class CreatePersonas < ActiveRecord::Migration[7.1]
  def change
    create_table :personas do |t|
      t.date :fecha_de_nacimiento
      t.string :profile
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
