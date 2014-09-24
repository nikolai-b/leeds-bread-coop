class CreateOrderCopies < ActiveRecord::Migration
  def change
    create_table :order_copies do |t|
      t.integer :week_num

      t.timestamps
    end
  end
end
