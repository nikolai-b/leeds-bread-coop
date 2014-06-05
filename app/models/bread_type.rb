class BreadType < ActiveRecord::Base
  has_many :subscriber_items
  has_many :subscribers, through: :subscriber_items
end
