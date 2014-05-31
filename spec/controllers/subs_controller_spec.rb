describe SubsController do
  include Devise::TestHelpers


  def setup
    @request.env["devise.mapping"] = Devise.mappings[:subscriber]
    sign_in subscriber
  end

  let(:subscriber) { create :subscriber }
  let(:valid_attributes) { {subscriber_id: subscriber.to_param } }
  let(:customer) { double('customer').tap {|c| c.stub(:id).and_return(1) } }

  before do
    setup
  end

  it do
    expect(Stripe::Customer).to receive(:create).and_return(customer)
    expect(Notifier).to receive(:new_sub)

    post :create,  valid_attributes
  end
end
