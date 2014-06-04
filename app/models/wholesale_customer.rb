class WholesaleCustomer < ActiveRecord::Base
  has_many :orders
end
