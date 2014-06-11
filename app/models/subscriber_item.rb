class SubscriberItem < ActiveRecord::Base
  belongs_to :subscriber
  belongs_to :bread_type
  validates :collection_day, numericality: { only_integer: true }
  scope :delivery_day, ->(date) { where(collection_day: date.wday) }

  def collection_day_name
    Date::DAYNAMES[collection_day]
  end

end
