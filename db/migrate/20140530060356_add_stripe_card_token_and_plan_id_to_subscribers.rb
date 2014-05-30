class AddStripeCardTokenAndPlanIdToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :stripe_card_token, :string
    add_column :subscribers, :plan_id, :string
  end
end
