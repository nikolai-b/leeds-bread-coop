class Holiday < ActiveRecord::Base
  belongs_to :subscriber, counter_cache: true

  validates :start_date, :end_date, :subscriber, presence: true
  validate :not_overlapping
  validate :not_in_the_past
  validate :end_date_after_start_date
  validate :start_date_too_close

  scope :in_last_week, ->{ t = Date.today; where(end_date: (t-6.days..t)) }


  def will_miss
    subscriber_collection_days = subscriber.collection_days
    (start_date..end_date).select{ |k| subscriber_collection_days.include?(k.wday) }.size
  end

  private

  def not_overlapping
    return unless start_date && end_date && subscriber
    subscriber.holidays.reject{ |h| h.id == id }.each do |other_holiday|
      if (other_holiday.start_date..other_holiday.end_date).include? start_date
        errors.add :start_date, 'overlaps another holiday'
      end
      if (other_holiday.start_date..other_holiday.end_date).include? end_date
        errors.add :end_date, 'overlaps another holiday'
      end
    end
  end

  def not_in_the_past
    return unless start_date
    errors.add :start_date, 'is in the past' if start_date < Date.current
  end

  def end_date_after_start_date
    return unless start_date && end_date && subscriber
    errors.add :end_date, 'must be after start date' if end_date <= start_date
  end

  def start_date_too_close
    return unless start_date
    errors.add :start_date, 'is too close and your bread has been started' if start_date < Date.current + 3.days
  end
end
