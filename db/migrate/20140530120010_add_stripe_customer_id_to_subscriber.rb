class AddStripeCustomerIdToSubscriber < ActiveRecord::Migration
  def change
    add_column :subscribers, :stripe_customer_id, :integer
  end
end
