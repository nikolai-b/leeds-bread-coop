class CreateSubscriberItems < ActiveRecord::Migration
  def change
    create_table :subscriber_items do |t|
      t.references :subscriber, index: true
      t.references :bread_type, index: true

      t.timestamps
    end
  end
end
