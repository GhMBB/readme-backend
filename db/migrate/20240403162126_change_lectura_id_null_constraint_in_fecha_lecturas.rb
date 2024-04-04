class ChangeLecturaIdNullConstraintInFechaLecturas < ActiveRecord::Migration[7.1]
  def change
    change_column_null :fecha_lecturas, :lectura_id, true
  end
end
