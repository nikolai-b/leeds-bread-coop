class AddRegularToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :regular, :boolean
  end
end
