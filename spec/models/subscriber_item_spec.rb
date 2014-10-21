require 'spec_helper'

describe Subscription do
  context 'with a stipe customer id' do
    let(:subscriber) { create :subscriber, stripe_customer_id: "stripeid" }

    it 'updates stripe if a subscription is created or destroyed' do
      expect(subscriber.stripe_sub).to receive(:update).twice.and_return(true)
      si = create :subscription, subscriber: subscriber
      si.destroy
    end

    it 'validates bread is avaliable for subscribers' do
      subscriber_bread = create :bread_type
      wholesale_bread = create :bread_type, wholesale_only: true

      subscription = build :subscription, bread_type: subscriber_bread
      expect(subscription.valid?).to be_truthy

      subscription.bread_type = wholesale_bread
      expect(subscription.valid?).to be_falsey
    end
  end
end
