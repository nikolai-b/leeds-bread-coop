class RenamePaidToInvoicedOnOrder < ActiveRecord::Migration
  def change
    rename_column :orders, :paid, :invoiced
  end
end
