class AddPaidToSubscriberItem < ActiveRecord::Migration
  def change
    add_column :subscriber_items, :paid, :boolean
  end
end
