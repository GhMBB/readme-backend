class AddModeradorToSolicitudDesbaneo < ActiveRecord::Migration[7.1]
  def change
    add_reference :solicitud_desbaneos, :moderador, null: true, foreign_key: { to_table: :users }
  end
end
