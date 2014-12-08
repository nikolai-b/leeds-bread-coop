class MoveStripeCustomerIdFromSubscribers < ActiveRecord::Migration
  def change
    execute "INSERT INTO stripe_accounts (subscriber_id, customer_id)
SELECT id, stripe_customer_id FROM subscribers
WHERE stripe_customer_id IS NOT NULL"
    remove_column :subscribers, :stripe_customer_id, :string
  end
end
