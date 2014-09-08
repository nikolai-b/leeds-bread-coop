class AddDefaultToPaidOnSubscriptionItems < ActiveRecord::Migration
  def change
    change_column_default(:subscriber_items, :paid, false)
  end
end
