class SubscriberItem < ActiveRecord::Base
  belongs_to :subscriber
  belongs_to :bread_type
  validates :collection_day, numericality: { only_integer: true }
  scope :delivery_day, ->(date) { where(collection_day: date.wday) }
  validate :change_subscription_ok, on: :update

  def collection_day_name
    Date::DAYNAMES[collection_day]
  end

  private

  def change_subscription_ok
    if (bread_type_id_changed?)
      wday = Date.today.wday
      if (wday..wday + 3).include? collection_day
        errors.add(:bread_type_id,"can't be change untill the day after collection, your bread has already been baked for this week")
      end
    end
    if (collection_day_changed?)
      wday = Date.today.wday
      if (wday..wday + 3).include? collection_day
        errors.add(:collection_day,"that is too soon, it takes us 3 days to make your bread")
      end
    end
  end
end
