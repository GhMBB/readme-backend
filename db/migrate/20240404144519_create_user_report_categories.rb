class CreateUserReportCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :user_report_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end
