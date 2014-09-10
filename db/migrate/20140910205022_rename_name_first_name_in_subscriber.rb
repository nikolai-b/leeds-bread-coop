class RenameNameFirstNameInSubscriber < ActiveRecord::Migration
  def change
    rename_column :subscribers, :name, :first_name
  end
end
