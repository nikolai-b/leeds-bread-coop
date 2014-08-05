class Holiday < ActiveRecord::Base
  belongs_to :subscriber

  def will_miss
    subscriber_collection_days = subscriber.collection_days
    (start_date..end_date).inject(0) do |sum, k|
      1 + sum if subscriber_collection_days.include?(k.wday)
    end
  end
end
