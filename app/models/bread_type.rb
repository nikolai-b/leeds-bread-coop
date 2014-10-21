class BreadType < ActiveRecord::Base
  has_many :subscriptions
  has_many :subscribers, through: :subscriptions
  scope :for_subscribers, -> { where(wholesale_only: false) }
end
