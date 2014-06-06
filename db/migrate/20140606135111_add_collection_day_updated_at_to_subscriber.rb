class AddCollectionDayUpdatedAtToSubscriber < ActiveRecord::Migration
  def change
    add_column :subscribers, :collection_day_updated_at, :date
  end
end
