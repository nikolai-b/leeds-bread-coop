class AddCollectionDayToSubscriber < ActiveRecord::Migration
  def change
    add_column :subscribers, :collection_day, :integer
  end
end
