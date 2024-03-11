class CreateLecturas < ActiveRecord::Migration[7.1]
  def change
    create_table :lecturas do |t|
      t.references :user, null: false, foreign_key: true
      t.references :libro, null: false, foreign_key: true
      t.date :fecha
      t.timestamps
    end
  end
end
