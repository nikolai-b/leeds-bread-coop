require 'spec_helper'

describe SubscriberItem do
  context 'with a stipe customer id' do
    let(:subscriber) { create :subscriber, stripe_customer_id: "stripeid" }

    it 'updates stripe if a subscription is created or destroyed' do
      expect(subscriber.stripe_sub).to receive(:update).twice.and_return(true)
      si = create :subscriber_item, subscriber: subscriber
      si.destroy
    end
  end
end
