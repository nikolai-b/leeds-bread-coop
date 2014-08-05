class AddHolidaysCountToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :holidays_count, :integer, default: 0, null: false
    Subscriber.all.each do |subscriber|
      Subscriber.reset_counters(subscriber.id, :holidays)
    end
  end
end
