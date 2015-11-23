require 'spec_helper'

describe Subscription do
  subject { create :subscription }

  let(:subscriber) { create :subscriber, :with_subscription }

  context 'with a stipe customer id' do

    let(:mon) { Date.today.beginning_of_week }

    it 'updates stripe if a subscription is created or destroyed' do
      expect(subscriber.stripe_account).to receive(:update_stripe).twice.and_return(true)
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
      allow(Date).to receive(:today).and_return(mon + 2.days)

      expect(subject.instant_change?).to be_truthy

      subject.bread_type = create :bread_type
      expect(subject.instant_change?).to be_falsey

      allow(Date).to receive(:today).and_return(mon - 1.day)
      expect(subject.instant_change?).to be_truthy

      subject.collection_day = 2
      expect(subject.instant_change?).to be_falsey

      allow(Date).to receive(:today).and_return(mon + 2.days)
      expect(subject.instant_change?).to be_falsey
    end

    context 'with deffered changes in real mode' do
      before do
        allow(described_class).to receive(:defer_changes_off?).and_return(false)
      end

      let(:subscriber) { subject.subscriber }

      it 'defers changes that that cannot be applied instantly' do
        allow(Date).to receive(:today).and_return(mon - 1.day)
        subject.update! collection_day: 2

        expect(subject.next_collection_day).to eq(2)
        expect(subject.collection_day).to eq(4)
      end

      it 'as admin skips checks for instant changes' do
        allow(Date).to receive(:today).and_return(mon - 1.day)

        subscriber.update( {subscriptions_attributes:
                           {"1437125740314" => subject.attributes.merge(collection_day: 2) }})
        subscriber.reload

        expect(subscriber.subscriptions.map(&:collection_day)).to_not include(2)

        subscriber.update( {subscriptions_attributes:
                           {"1437125740314" => subject.attributes.merge(as_admin: true, collection_day: 2) }})
        subscriber.reload

        expect(subscriber.subscriptions.map(&:collection_day)).to include(2)
      end
    end

    context 'with defered changes' do
      let!(:changed_bread_type) { create :subscription, next_bread_type: new_bread_type, next_collection_day: 4 }
      let!(:changed_fri_to_wed) { create :subscription, next_bread_type: old_bread_type, next_collection_day: 2, bread_type: old_bread_type }
      let!(:unchaged)           { create :subscription, updated_at: (Time.now - 1.day) }

      let(:new_bread_type) { create :bread_type }
      let(:old_bread_type) { changed_bread_type.bread_type }


      it 'applies defered changes' do
        expect{ described_class.apply_defered_changes! }.to_not change{ unchaged.reload.updated_at }

        expect(changed_bread_type.reload.next_bread_type).to be_nil
        expect(changed_bread_type.next_collection_day).to be_nil
        expect(changed_bread_type.bread_type).to eq(new_bread_type)
        expect(changed_bread_type.collection_day).to eq(4)

        expect(changed_fri_to_wed.reload.next_bread_type).to be_nil
        expect(changed_fri_to_wed.next_collection_day).to be_nil
        expect(changed_fri_to_wed.collection_day).to eq(2)
        expect(changed_fri_to_wed.bread_type).to eq(old_bread_type)
      end

      it 'validates collection_day is in collection_point valid_days' do
        subject.subscriber.collection_point.update! valid_days: [2]
        subject.reload.collection_day = 2
        expect(subject.valid?).to be_truthy

        subject.collection_day = 4
        expect(subject.valid?).to be_falsey
      end

    end
  end
end
