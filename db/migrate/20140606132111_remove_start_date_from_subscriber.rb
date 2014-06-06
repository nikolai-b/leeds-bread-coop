class RemoveStartDateFromSubscriber < ActiveRecord::Migration
  def change
    remove_column :subscribers, :start_date, :date
  end
end
