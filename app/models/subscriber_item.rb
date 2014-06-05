class SubscriberItem < ActiveRecord::Base
  belongs_to :subscriber
  belongs_to :bread_type
end
