describe StripeSubsController do
  def setup
    @request.env["devise.mapping"] = Devise.mappings[:subscriber]
    sign_in subscriber
  end

  let(:subscriber) { create :subscriber }
  let(:valid_attributes) { {} }
  let(:customer) { double('customer', id: 1) }
  let(:notifier) { double('customer', new_sub: true) }

  before do
    setup
    StripeMock.start
    Stripe::Plan.create(id: 'weekly-bread-0', amount: 0)
  end

  after { StripeMock.stop }

  it do
    expect(SubscriberNotifier).to receive(:new).with(subscriber).and_return(notifier)

    post :create,  valid_attributes
  end
end
