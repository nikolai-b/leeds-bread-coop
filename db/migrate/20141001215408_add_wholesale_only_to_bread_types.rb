class AddWholesaleOnlyToBreadTypes < ActiveRecord::Migration
  def change
    add_column :bread_types, :wholesale_only, :boolean, default: false
  end
end
