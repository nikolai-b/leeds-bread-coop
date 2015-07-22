class AddPaymentTypeIdToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :payment_type_id, :integer
  end
end
