class AddDeletedToAllTables < ActiveRecord::Migration[7.1]
  def change
    #add_column :all_tables, :deleted, :boolean
    # Obtenemos todas las tablas de la base de datos
    tables = ActiveRecord::Base.connection.tables - ['schema_migrations']

    tables.each do |table|
      # Agregamos el campo deleted:boolean a cada tabla
      add_column table.to_sym, :deleted, :boolean, default: false
    end
  end
end
