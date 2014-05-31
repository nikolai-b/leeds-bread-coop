class AddHasActiveSubToSubscriber < ActiveRecord::Migration
  def change
    add_column :subscribers, :has_active_sub, :boolean
  end
end
