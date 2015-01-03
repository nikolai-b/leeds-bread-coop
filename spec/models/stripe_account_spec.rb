describe StripeAccount, mock_stripe: true do
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:subscriber) { create :subscriber }
  let(:card_token) { stripe_helper.generate_card_token }
  let!(:subscription) { create :subscription, subscriber: subscriber, paid: false }

  before do
    Stripe::Plan.create(id: 'weekly-bread-2', amount: 2000, name: 'weekly-sub_2', currency: 'GBP', interval: 4)
  end

  subject { subscriber.create_stripe_account }

  describe '#add_token' do
    context 'with no current sub' do
      it 'sets the subscriber\'s stripe id and active sub' do
        subject.add_token(card_token)

        expect(subject.reload.customer_id).to_not be_nil
        expect(subject.last4).to eq(4242)
      end

      it 'sets the subscribers active sub' do
        expect{subject.add_token(card_token)}.to change{subscriber.reload.num_paid_subs}.by(1)
      end

      it 'returns true' do
        expect(subject.add_token(card_token)).to be_truthy
      end
    end
  end

  context 'with a stipe account' do
    before do
      subject.add_token(card_token)
    end

    describe '#cancel' do
      let(:notifier) { double('SubscriberNotifier', new_sub: true, sub_deleted: true) }

      it 'updates num_paid_subs to nil' do
        expect(notifier).to receive(:sub_deleted).once.and_return nil
        subscriber.reload
        expect{ subject.cancel(notifier) }.to change{subscriber.num_paid_subs}.by(-1)
      end

      it 'returns true' do
        expect(notifier).to receive(:sub_deleted).once.and_return nil
        expect(subject.cancel(notifier)).to be_truthy
      end
    end

    describe '#update' do
      it 'marks all subscriptions as paid' do
        subscription = create :subscription, subscriber: subscriber, paid: false
        subject.reload.update_stripe
        expect(subscription.reload.paid).to be_truthy
      end

      it 'set plan equal to number of subscriptions' do
        create :subscription, subscriber: subscriber

        subject.reload.update_stripe
        stripe = Stripe::Customer.retrieve(subject.customer_id)

        expect(stripe.subscriptions.first.plan.id).to eq('weekly-bread-2')
      end
    end

    describe '#refund' do
      let!(:charge) { Stripe::Charge.create customer: subject.customer_id, amount: 1000, currency: 'GBP' }

      it 'refunds the charges' do
        skip
        subject.refund_weeks 5

        expect(charges[0]['data'].refunds).to be_blank
        expect(charges[1]['data'].refunds).to be_blank
        expect(charges[2]['data'].refunds).to be_blank
      end

      it 'refunds holidays ending in last week' do
        hol_two_weeks = build :holiday, subscriber: subscriber, start_date: (Date.today.beginning_of_week - 14.days), end_date: (Date.today.beginning_of_week)
        hol_two_weeks.save validate: false
        described_class.refund_holidays
        refund = Stripe::Charge.retrieve(charge.id).refunds.first
        expect(refund.amount).to eq(500)
      end

    end
  end
end
