class SetDefaultOptionsToOrder < ActiveRecord::Migration
  def change
    change_column_default :orders, :invoiced, false
    change_column_default :orders, :regular, false
    change_column_default :orders, :sample, false
  end
end
