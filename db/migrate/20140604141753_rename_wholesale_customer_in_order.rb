class RenameWholesaleCustomerInOrder < ActiveRecord::Migration
  def change
    rename_column :orders, :wholesale_id, :wholesale_customer_id
  end
end
