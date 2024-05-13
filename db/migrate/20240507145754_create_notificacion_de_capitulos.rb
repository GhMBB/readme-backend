class CreateNotificacionDeCapitulos < ActiveRecord::Migration[7.1]
  def change
    create_table :notificacion_de_capitulos do |t|
      t.references :user, null: false, foreign_key: true
      t.references :libro, null: false, foreign_key: true
      t.boolean :deleted

      t.timestamps
    end
  end
end
