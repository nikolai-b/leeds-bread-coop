class AddNotesToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :notes, :text
  end
end
