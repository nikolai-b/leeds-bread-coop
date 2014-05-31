class AddLockableToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :failed_attempts, :integer, default: 0, null: false
    add_column :subscribers, :unlock_token, :string
    add_index :subscribers, :unlock_token, unique: true
    add_column :subscribers, :locked_at, :datetime
  end
end
