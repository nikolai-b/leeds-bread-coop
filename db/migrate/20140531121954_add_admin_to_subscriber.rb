class AddAdminToSubscriber < ActiveRecord::Migration
  def change
    add_column :subscribers, :admin, :boolean
  end
end
