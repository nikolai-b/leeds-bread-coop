require 'spec_helper'

describe "Stripe Billing Events" do
  def stub_event(event, status = 200)
    stub_request(:get, "https://api.stripe.com/v1/events/evt_#{event.sub('.', '_')}").
      to_return(status: status, body: StripeMock.mock_webhook_event(event) )
  end

  describe "customer.created" do
    before do
      stub_event 'customer.created'
    end

    it "is successful" do
      post '/stripe/events', id: 'evt_customer_created'
      expect(response.code).to eq "200"
      # Additional expectations...
    end
  end
end
