class AddDeletedByUserToTables < ActiveRecord::Migration[7.1]
  def change
    tables_with_deleted_and_user_id = ActiveRecord::Base.connection.tables.select do |table_name|
      columns = ActiveRecord::Base.connection.columns(table_name)
      columns.any? { |column| column.name == 'deleted' } && columns.any? { |column| column.name == 'user_id' }
    end

    tables_with_deleted_and_user_id.each do |table_name|
      add_column table_name, :deleted_by_user, :boolean
    end
  end
end
