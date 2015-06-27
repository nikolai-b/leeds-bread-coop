describe StripeAccount, mock_stripe: true do
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:subscriber) { create :subscriber }
  let(:card_token) { stripe_helper.generate_card_token }
  let!(:subscription) { create :subscription, subscriber: subscriber, paid_till: 28.days.from_now }

  before do
    Stripe::Plan.create(id: 'weekly-bread-2', amount: 2000, name: 'weekly-sub_2', currency: 'GBP', interval: 4)
  end

  subject { subscriber.create_stripe_account }

  describe '#add_token' do
    context 'with no current sub' do
      it 'sets the subscriber\'s stripe id and active sub' do
        subject.add_token(card_token)

        expect(subject.customer_id).to_not be_nil
        expect(subject.last4).to eq(4242)
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
      let(:notifier) { double('SubscriberNotifier', sub_deleted: true) }

      it 'updates num_paid_subs to nil' do
        subscriber.reload
        expect{ subject.cancel(notifier) }.to change(subscriber.subscriptions, :count).by(-1)
      end

      it 'returns true' do
        expect(subject.cancel(notifier)).to be_truthy
      end

      it 'notifies the subscriber' do
       expect(notifier).to receive(:sub_deleted).once
       subject.cancel(notifier)
      end
    end

    describe '#update' do
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
        hol_two_weeks = create :holiday, subscriber: subscriber, start_date: (Date.today.beginning_of_week + 14.days), end_date: (Date.today.beginning_of_week + 28.days)
        allow(Date).to receive(:today).and_return(Date.today + 28.days)

        described_class.refund_holidays
        refund = Stripe::Charge.retrieve(charge.id).refunds.first
        expect(refund.amount).to eq(500)
      end

      it 'should refunds n weeks' do
        subscriber.stripe_account.refund_weeks(2)
      end
    end
  end
end
