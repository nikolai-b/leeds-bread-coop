class RemoveCollectionDayFromSubscriber < ActiveRecord::Migration
  def change
    remove_column :subscribers, :collection_day, :date
  end
end
