class AddPaidTillToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :paid_till, :date
    remove_column :subscriptions, :paid, :boolean
  end
end
