describe StripeSub do
  let(:notifier) { double('SubscriberNotifier', new_sub: true, sub_deleted: true) }
  let(:subscriber) { create :subscriber}
  let(:stripe_helper) { StripeMock.create_test_helper }

  before do
    StripeMock.start
    Stripe::Plan.create(id: 'weekly-bread-1', amount: 1000, name: 'weekly-sub', currency: 'GBP', interval: 4)
  end

  after { StripeMock.stop }

  subject { StripeSub.new(subscriber, notifier)}

  describe '#add' do
    context 'with no current sub' do
      before do
        create :subscription, subscriber: subscriber
      end

      it 'sets the subscriber\'s stripe id and active sub' do
        subject.add(stripe_helper.generate_card_token)

        expect(subscriber.stripe_customer_id).to_not be_nil
        expect(subscriber.num_paid_subs).to eq(1)
        expect(subscriber.payment_card.last4).to eq(4242)
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

  describe '#cancel' do
    context 'happy path' do
      before do
        create :subscription, subscriber: subscriber
        subscriber.update stripe_customer_id: 'test_customer_sub'
        customer = Stripe::Customer.create(id: subscriber.stripe_customer_id, card: stripe_helper.generate_card_token)
      end

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
        subject.cancel
      end
    end
  end

  describe '#update' do
    before do
      create :subscription, subscriber: subscriber
      subscriber.update stripe_customer_id: 'test_customer_sub'
      customer = Stripe::Customer.create(id: subscriber.stripe_customer_id, card: stripe_helper.generate_card_token)
      customer.subscriptions.create({ :plan => 'weekly-bread-1' })
    end

    it 'marks all subscriptions as paid' do
      expect(subscriber).to receive(:mark_subscriptions_payment_as).once
      subject.update
    end

  end

  describe '#refund' do
    before do
      create :subscription, subscriber: subscriber
      subscriber.update stripe_customer_id: 'test_customer_sub'
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
  end

  it 'refunds subscribers in last week' do
    skip
    hol = build :holiday, subscriber: subscriber, end_date: (Date.today - 6.days)
    hol.save validate: false
    expect{ described_class.refund }
  end

end
