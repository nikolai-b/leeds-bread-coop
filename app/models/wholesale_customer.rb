class WholesaleCustomer < ActiveRecord::Base
  has_many :orders
  scope :ordered, -> { order(:name) }
end
