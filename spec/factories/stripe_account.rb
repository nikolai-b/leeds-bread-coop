require 'stripe_mock'

FactoryGirl.define do
  factory :stripe_account do
    subscriber
    last4 1234
    exp_year 2040
    exp_month 11
    after(:build) do |sa|
      sa.customer_id = Stripe::Customer.create(email: 'email_other@email.com', card: StripeMock.create_test_helper.generate_card_token(last4: sa.last4, exp_year: sa.exp_year), plan: 'weekly-bread-1').id
    end
  end
end

