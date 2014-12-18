require 'spec_helper'

describe Subscription do
  context 'with a stipe customer id' do
    include_context :stripe_customer

    subject { create :subscription }

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
      let!(:changed_bread_type) { create :subscription, next_bread_type: new_bread_type, next_collection_day: 5 }
      let!(:changed_fri_to_wed) { create :subscription, next_bread_type: old_bread_type, next_collection_day: 3, bread_type: old_bread_type }
      let!(:unchaged)           { create :subscription, updated_at: (Time.now - 1.day) }

      let(:new_bread_type) { create :bread_type }
      let(:old_bread_type) { changed_bread_type.bread_type }


      it 'applies defered changes' do
        expect{ described_class.apply_defered_changes! }.to_not change{ unchaged.reload.updated_at }

        expect(changed_bread_type.reload.next_bread_type).to be_nil
        expect(changed_bread_type.reload.next_collection_day).to be_nil
        expect(changed_bread_type.reload.bread_type).to eq(new_bread_type)
        expect(changed_bread_type.reload.collection_day).to eq(5)

        expect(changed_fri_to_wed.reload.next_bread_type).to be_nil
        expect(changed_fri_to_wed.reload.next_collection_day).to be_nil
        expect(changed_fri_to_wed.reload.collection_day).to eq(3)
        expect(changed_fri_to_wed.reload.bread_type).to eq(old_bread_type)
      end

    end
  end
end
