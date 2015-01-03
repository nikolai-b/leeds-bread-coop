class Subscription < ActiveRecord::Base
  belongs_to :subscriber
  belongs_to :bread_type
  belongs_to :next_bread_type, class: BreadType

  validates :collection_day, inclusion: [3, 5]
  validates :next_collection_day, inclusion: [3, 5], allow_blank: true
  validates :bread_type, presence: true
  validate  :bread_type_for_subscribers

  scope :delivery_day, ->(date) { where(collection_day: date.wday) }
  scope :with_changes, ->       { where.not(next_collection_day: nil) }
  scope :active, ->             { where.not(collection_day: nil) }

  before_save    :defer_changes
  before_create  :update_stripe
  before_destroy :update_stripe

  def self.apply_defered_changes!
    where.not(next_collection_day: nil).find_each &:apply_defered_changes!
  end

  def collection_day_name
    Date::DAYNAMES[collection_day]
  end

  def next_collection_day_name
    Date::DAYNAMES[next_collection_day]
  end

  def instant_change?
    if (bread_type_id_changed? || collection_day_changed?)
      wday = Date.today.wday
      if ((wday..wday + 3).to_a & [collection_day, collection_day_was]).present?
        return false
      end
    end
    return true
  end

  def apply_defered_changes!
    update! bread_type_id: next_bread_type_id, collection_day: next_collection_day
    update! next_bread_type_id: nil, next_collection_day: nil
  end

  private

  def defer_changes
    return if instant_change? || self.class.defer_changes_off?
    self.next_bread_type_id = bread_type_id
    self.bread_type_id = bread_type_id_was
    self.next_collection_day = collection_day
    self.collection_day = collection_day_was
  end

  def bread_type_for_subscribers
    unless bread_type_id.in? BreadType.for_subscribers.pluck(:id)
      errors.add(:bread_type_id, "must be a bread avaliable to subscribers")
    end
  end

  def update_stripe
    subscriber.stripe_account.update_stripe if subscriber.stripe_account
  end

  def self.defer_changes_off?
    Rails.env.test?
  end
end
