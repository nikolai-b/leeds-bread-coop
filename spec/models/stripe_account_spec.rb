describe StripeAccount do
  let(:notifier) { double('SubscriberNotifier', new_sub: true, sub_deleted: true) }
  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:subscriber) { create :subscriber, :with_subscription, customer_id: customer_id }
  let(:card_tok) { stripe_helper.generate_card_token }
  let(:customer_id) { (Stripe::Customer.create email: 'email@email.com', card: card_tok, plan: 'weekly-bread-1').id }
  let(:charge) { Stripe::Charge.create customer: customer_id, amount: 1000, currency: 'GBP' }

  before do
    StripeMock.start
    Stripe::Plan.create(id: 'weekly-bread-1', amount: 1000, name: 'weekly-sub', currency: 'GBP', interval: 4)
    Stripe::Plan.create(id: 'weekly-bread-2', amount: 2000, name: 'weekly-sub_2', currency: 'GBP', interval: 4)
  end

  after { StripeMock.stop }

  subject { subscriber.build_stripe_account }

  describe '#add' do
    context 'with no current sub' do
      it 'sets the subscriber\'s stripe id and active sub' do
        subject.update_colunm :customer_id, nil

        subject.add(stripe_helper.generate_card_token)

        expect(subject.reload.customer_id).to_not be_nil
        expect(subject.last4).to eq(4242)
        expect(subscriber.num_paid_subs).to eq(1)
      end

      it 'returns true' do
        expect(subject.add(stripe_helper.generate_card_token)).to be_truthy
      end
    end

    context 'with no current sub but with Stripe::APIError' do
      before do
        Stripe::Customer.stub(:create).and_raise(Stripe::APIError)
      end

      it "adds errors to base" do
        expect(subject.errors).to be_empty

        subject.add('strip_token')

        expect(subject.errors).to_not be_empty
      end

      it 'returns false' do
        expect(subject.add('strip_token')).to be_falsey
      end
    end
  end

  context 'with a stipe account' do
    before do
      token = stripe_helper.generate_card_token
      subject.update customer_id: token
      Stripe::Customer.create(id: subscriber.stripe_customer_id, card: token)
    end

    describe '#cancel' do
      it 'updates num_paid_subs to nil' do
        expect(subscriber.num_paid_subs).to_not eq(0)
        subject.cancel
        expect(subscriber.num_paid_subs).to eq(0)
      end

      it 'returns true' do
        expect(subject.cancel).to be_truthy
      end

      it 'sends an new_sub email' do
        expect(notifier).to receive(:sub_deleted)
        subject.cancel(notifier)
      end
    end

    describe '#update' do
      it 'marks all subscriptions as paid' do
        subscription = create :subscription, subscriber: subscriber, paid: false
        subject.update_stripe
        expect(subscription.reload.paid).to be_truthy
      end

      it 'marks all subscriptions as paid' do
        subscription = create :subscription, subscriber: subscriber, paid: false
        subject.update_stripe
        stipe = Stripe::Customer.retrieve(subject.customer_id)
        expect(stipe.subscriptions.first.plan).to eq('weekly-bread-2')
      end
    end
  end

  describe '#refund' do
    before do
      subject.customer_id = customer_id
      subject.save! validate: false
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
      charge
      hol_two_weeks = build :holiday, subscriber: subscriber, start_date: (Date.today.beginning_of_week - 14.days), end_date: (Date.today.beginning_of_week)
      hol_two_weeks.save validate: false
      described_class.refund_holidays
      refund = Stripe::Charge.retrieve(charge.id).refunds.first
      expect(refund.amount).to eq(500)
    end

  end

end
