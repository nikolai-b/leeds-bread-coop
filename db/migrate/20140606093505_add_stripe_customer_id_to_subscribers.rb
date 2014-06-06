class AddStripeCustomerIdToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :stripe_customer_id, :string
  end
end
