describe SubsController do
  include Devise::TestHelpers


  def setup
    @request.env["devise.mapping"] = Devise.mappings[:subscriber]
    sign_in subscriber
  end

  let(:subscriber) { create :subscriber }
  let(:valid_attributes) { {subscriber_id: subscriber.to_param } }
  let(:customer) { double('customer', id: 1) }
  let(:notifier) { double('customer', new_sub: true) }

  before do
    setup
  end

  it do
    expect(Stripe::Customer).to receive(:create).and_return(customer)
    expect(SubscriberNotifier).to receive(:new).with(subscriber).and_return(notifier)

    post :create,  valid_attributes
  end
end
