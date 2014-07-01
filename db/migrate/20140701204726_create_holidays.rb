class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.date :start_date
      t.date :end_date
      t.references :subscriber, index: true

      t.timestamps
    end
  end
end
