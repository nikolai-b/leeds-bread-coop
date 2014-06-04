class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :order, index: true
      t.references :bread_type, index: true
      t.integer :quantity

      t.timestamps
    end
  end
end
