class RenameWeekNumber < ActiveRecord::Migration
  def change
    rename_table :order_copies, :weeks
  end
end
