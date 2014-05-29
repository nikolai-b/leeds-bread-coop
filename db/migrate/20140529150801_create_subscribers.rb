class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers do |t|
      t.string :name
      t.text :address
      t.string :phone
      t.references :collection_point, index: true
      t.date :start_date
      t.date :paid_until
      t.references :bread_type, index: true
      t.integer :quantity

      t.timestamps
    end
  end
end
