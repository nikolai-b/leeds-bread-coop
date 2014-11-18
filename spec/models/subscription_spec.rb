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

    it 'checks it changes can be instantly applied' do
      mon = Date.today.beginning_of_week
      allow(Date).to receive(:today).and_return(mon + 3.days)

      subscriber.paid = !subscriber.paid
      expect(subscriber.instant_change?).to be_truthy

      subscriber.bread_type = create :bread_type
      expect(subscriber.instant_change?).to be_falsey

      allow(Date).to receive(:today).and_return(mon + 1.days)
      expect(subscriber.instant_change?).to be_truthy

      subscriber.collection_day = 3
      expect(subscriber.instant_change?).to be_falsey
    end
  end
end
