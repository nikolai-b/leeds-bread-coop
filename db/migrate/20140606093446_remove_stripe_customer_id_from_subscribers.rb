class RemoveStripeCustomerIdFromSubscribers < ActiveRecord::Migration
  def change
    remove_column :subscribers, :stripe_customer_id, :integer
  end
end
