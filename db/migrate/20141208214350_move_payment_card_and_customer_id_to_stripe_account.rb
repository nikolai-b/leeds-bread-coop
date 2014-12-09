class MovePaymentCardAndCustomerIdToStripeAccount < ActiveRecord::Migration
  def change
    execute "INSERT INTO stripe_accounts (subscriber_id, customer_id, last4, exp_year, exp_month)
             SELECT
               s.id                 as subscriber_id,
               s.stripe_customer_id as customer_id,
               pc.last4             as last4,
               pc.exp_year          as exp_year,
               pc.exp_month         as exp_month
             FROM subscribers s
             INNER JOIN payment_cards pc
                ON pc.subscriber_id = s.id
             WHERE stripe_customer_id IS NOT NULL"
    remove_column :subscribers, :stripe_customer_id, :string
    drop_table :payment_cards
  end
end
