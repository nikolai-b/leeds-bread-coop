class AddInvoiceTypeIdToWholesaleCustomers < ActiveRecord::Migration
  def change
    add_column :wholesale_customers, :invoice_type_id, :integer
    remove_column :orders, :invoiced, :boolean
  end
end
