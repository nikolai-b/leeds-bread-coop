describe StripeAccount do
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:subscriber) { create :subscriber, :with_subscription, customer_id: stripe_customer.id }
  let(:card_token) { stripe_helper.generate_card_token }
  let(:stripe_customer) { Stripe::Customer.create email: 'email@email.com', card: stripe_helper.generate_card_token, plan: 'weekly-bread-1' }
  let(:default_account) { build :stripe_account }

  before do
    StripeMock.start
    Stripe::Plan.create(id: 'weekly-bread-1', amount: 1000, name: 'weekly-sub', currency: 'GBP', interval: 4)
    Stripe::Plan.create(id: 'weekly-bread-2', amount: 2000, name: 'weekly-sub_2', currency: 'GBP', interval: 4)
  end

  after { StripeMock.stop }

  subject { subscriber.build_stripe_account default_account.attributes }

  describe '#add' do
    context 'with no current sub' do
      it 'sets the subscriber\'s stripe id and active sub' do
        subject.save
        subject.update_column :customer_id, nil

        subject.add(card_token)

        expect(subject.reload.customer_id).to_not be_nil
        expect(subject.last4).to eq(4242)
        expect(subscriber.num_paid_subs).to eq(1)
      end

      it 'returns true' do
        expect(subject.add(card_token)).to be_truthy
      end
    end
  end

  context 'with a stipe account' do

    before do
      subject.update customer_id: stripe_customer.id
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

    context 'with a subscription' do
      before do
        stripe_customer.plan = 'weekly-bread-1'
        stripe_customer.save
      end

      describe '#update' do
        it 'marks all subscriptions as paid' do
          subscription = create :subscription, subscriber: subscriber, paid: false
          subject.reload.update_stripe
          expect(subscription.reload.paid).to be_truthy
        end

        it 'set plan equal to number of subscriptions' do
          subscription = create :subscription, subscriber: subscriber, paid: false
          subject.reload.update_stripe
          stripe = Stripe::Customer.retrieve(subject.customer_id)

          expect(stripe.subscriptions.first.plan.id).to eq('weekly-bread-2')
        end
      end
    end
  end

  describe '#refund' do
    let!(:charge) { Stripe::Charge.create customer: stripe_customer.id, amount: 1000, currency: 'GBP' }

    before do
      subject.customer_id = stripe_customer.id
      subject.save!
      # StripeMock.stop
      # WebMock.disable_net_connect!
      # Stripe::Customer.create(id: subscriber.stripe_customer_id, card: stripe_helper.generate_card_token)
    end

    #let(:charges) { 3.times.collect { Stripe::Charge.create(amount: 1000, customer: subscriber.stripe_customer_id) } }

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
