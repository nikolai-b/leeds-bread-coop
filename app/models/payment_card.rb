class PaymentCard < ActiveRecord::Base
  belongs_to :subscriber
end
