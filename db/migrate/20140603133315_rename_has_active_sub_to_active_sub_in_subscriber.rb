class RenameHasActiveSubToActiveSubInSubscriber < ActiveRecord::Migration
  def change
    rename_column :subscribers, :has_active_sub, :active_sub
  end
end
