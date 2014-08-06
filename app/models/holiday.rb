class Holiday < ActiveRecord::Base
  belongs_to :subscriber, counter_cache: true

  validate :not_overlapping

  def will_miss
    subscriber_collection_days = subscriber.collection_days
    (start_date..end_date).select{ |k| subscriber_collection_days.include?(k.wday) }.size
  end

  private

  def not_overlapping
    return unless start_date && end_date && subscriber
    subscriber.holidays.reject{ |h| h.id == id }.each do |other_holiday|
      if (other_holiday.start_date..other_holiday.end_date).include? start_date
        errors.add :start_date, "overlaps another holiday"
      end
      if (other_holiday.start_date..other_holiday.end_date).include? end_date
        errors.add :end_date, "overlaps another holiday"
      end
    end
  end
end
