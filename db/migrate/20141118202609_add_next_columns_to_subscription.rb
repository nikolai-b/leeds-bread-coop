class AddNextColumnsToSubscription < ActiveRecord::Migration
  def change
    add_reference :subscriptions, :next_bread_type, index: true
    add_column :subscriptions, :next_collection_day, :integer
  end
end
