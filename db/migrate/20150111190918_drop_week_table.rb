class DropWeekTable < ActiveRecord::Migration
  def change
    drop_table :weeks
  end
end
