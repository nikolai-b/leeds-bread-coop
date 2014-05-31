class RemovePaidUntilAndQuantityFromSubscribers < ActiveRecord::Migration
  def change
    remove_column :subscribers, :paid_until, :date
    remove_column :subscribers, :quantity, :integer
  end
end
