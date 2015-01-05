class AddValidDaysToCollectionPoints < ActiveRecord::Migration
  def change
    add_column :collection_points, :valid_days, :text
    update "UPDATE collection_points SET valid_days = '#{YAML.dump([3,5])}'"
  end
end
