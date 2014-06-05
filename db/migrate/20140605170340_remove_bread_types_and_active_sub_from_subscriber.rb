class RemoveBreadTypesAndActiveSubFromSubscriber < ActiveRecord::Migration
  def change
    remove_reference :subscribers, :bread_type, index: true
    remove_column :subscribers, :active_sub, :boolean
  end
end
