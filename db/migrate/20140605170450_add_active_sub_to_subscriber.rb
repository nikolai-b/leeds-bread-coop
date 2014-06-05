class AddActiveSubToSubscriber < ActiveRecord::Migration
  def change
    add_column :subscribers, :active_sub, :integer
  end
end
