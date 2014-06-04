class CreateWholesaleCustomers < ActiveRecord::Migration
  def change
    create_table :wholesale_customers do |t|
      t.string :name
      t.text :address
      t.string :phone
      t.time :opening_time

      t.timestamps
    end
  end
end
