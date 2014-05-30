class RemoveStripeCardTokenAndPlanIdFromSubscriber < ActiveRecord::Migration
  def change
    remove_column :subscribers, :stripe_card_token, :string
    remove_column :subscribers, :plan_id, :string
  end
end
