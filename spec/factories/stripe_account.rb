FactoryGirl.define do
  factory :stripe_account do
    subscriber
    customer_id 'tok'
    last4 1234
    exp_year 2040
    exp_month 11
  end
end

