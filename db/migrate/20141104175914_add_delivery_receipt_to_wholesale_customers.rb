class AddDeliveryReceiptToWholesaleCustomers < ActiveRecord::Migration
  def change
    add_column :wholesale_customers, :delivery_receipt, :boolean, default: false
  end
end
