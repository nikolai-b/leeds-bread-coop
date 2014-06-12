class RemoveNumPaidSubsFromSubscriber < ActiveRecord::Migration
  def change
    remove_column :subscribers, :num_paid_subs, :integer
  end
end
