class RenameActiveSubToNumPaidSubs < ActiveRecord::Migration
  def change
    rename_column :subscribers, :active_sub, :num_paid_subs
  end
end
