shared_context :stripe_customer do
  before do
    StripeMock.start
    Stripe::Plan.create(id: 'weekly-bread-1', amount: 1000, name: 'weekly-sub', currency: 'GBP', interval: 4)
  end

  after { StripeMock.stop }

  let(:stripe_customer)       { Stripe::Customer.create email: 'email@email.com', card: stripe_helper.generate_card_token, plan: 'weekly-bread-1' }
  let(:stripe_customer_other) { Stripe::Customer.create email: 'email_other@email.com', card: stripe_helper.generate_card_token, plan: 'weekly-bread-1' }
  let(:stripe_helper)         { StripeMock.create_test_helper }
  let(:subscriber)            { create :subscriber, :with_subscription, customer_id: stripe_customer.id }
  let(:subscriber_other)      { create :subscriber, :with_subscription, customer_id: stripe_customer_other.id }
end
