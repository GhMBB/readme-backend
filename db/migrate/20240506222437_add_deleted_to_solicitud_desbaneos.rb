class AddDeletedToSolicitudDesbaneos < ActiveRecord::Migration[7.1]
  def change
    add_column :solicitud_desbaneos, :deleted, :boolean
  end
end
