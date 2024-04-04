class CreateBookReportCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :book_report_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
