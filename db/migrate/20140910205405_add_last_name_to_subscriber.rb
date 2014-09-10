class AddLastNameToSubscriber < ActiveRecord::Migration
  def change
    add_column :subscribers, :last_name, :string
  end
end
