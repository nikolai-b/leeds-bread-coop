class AddCollectionDayToSubscriberItem < ActiveRecord::Migration
  def change
    add_column :subscriber_items, :collection_day, :integer
  end
end
