class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :wholesale, index: true
      t.date :date
      t.boolean :paid

      t.timestamps
    end
  end
end
