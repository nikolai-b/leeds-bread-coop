class RenameSubscriptions < ActiveRecord::Migration
  def change
    rename_table :subscriber_items, :subscriptions
  end
end
