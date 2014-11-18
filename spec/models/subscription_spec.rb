require 'spec_helper'

describe Subscription do
  context 'with a stipe customer id' do
    subject { create :subscription }

    let(:subscriber) { create :subscriber, stripe_customer_id: "stripeid" }
    let(:mon) { Date.today.beginning_of_week }

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
      allow(Date).to receive(:today).and_return(mon + 3.days)

      subject.paid = !subject.paid
      expect(subject.instant_change?).to be_truthy

      subject.bread_type = create :bread_type
      expect(subject.instant_change?).to be_falsey

      allow(Date).to receive(:today).and_return(mon)
      expect(subject.instant_change?).to be_truthy

      subject.collection_day = 3
      expect(subject.instant_change?).to be_falsey

      allow(Date).to receive(:today).and_return(mon + 3.days)
      expect(subject.instant_change?).to be_falsey
    end

    it 'defers changes that that cannot be applied instantly' do
      allow(described_class).to receive(:defer_changes_off?).and_return(false)
      allow(Date).to receive(:today).and_return(mon)
      subject.update! collection_day: 3

      expect(subject.next_collection_day).to eq(3)
      expect(subject.collection_day).to eq(5)
    end

    context 'with defered changes' do
      let!(:fri_to_wed) { create :subscription, next_collection_day: 3, next_bread_type: bread_type, bread_type: bread_type }
      let!(:bread_type) { create :bread_type }
      let!(:new_bread_type) { create :subscription, next_bread_type: bread_type, next_collection_day: 5 }
      let!(:unchaged) { create :subscription }

      it 'applies defered changes' do
        described_class.apply_defered_changes!

        expect(unchaged).to eq(unchaged.reload)

        expect(new_bread_type.reload.next_bread_type).to be_nil
        expect(new_bread_type.reload.next_collection_day).to be_nil
        expect(new_bread_type.reload.bread_type).to eq(bread_type)

        expect(fri_to_wed.reload.next_bread_type).to be_nil
        expect(fri_to_wed.reload.next_collection_day).to be_nil
        expect(fri_to_wed.reload.collection_day).to eq(3)
      end

    end
  end
end
