describe StripeSub do
  let(:notifier) { double('SubscriberNotifier', new_sub: true, sub_deleted: true) }
  let(:subscriber) { create :subscriber}

  before do
    StripeMock.start
    Stripe::Plan.create(id: 'weekly-bread-1', amount: 500)
  end

  after { StripeMock.stop }

  subject { StripeSub.new(subscriber, notifier)}

  describe '#add' do
    context 'with no current sub' do
      before do
        Stripe::Plan.create(id: 'weekly-bread-1', amount: 500)
        create :subscriber_item, subscriber: subscriber
      end

      it 'sends an new_sub email' do
        expect(notifier).to receive(:new_sub)
        subject.add('strip_token')
      end

      it 'sets the subscriber\'s stripe id and active sub' do
        subject.add('stripe_token')

        expect(subscriber.stripe_customer_id).to_not be_nil
        expect(subscriber.num_paid_subs).to eq(1)
        expect(subscriber.payment_card.last4).to eq(4242)
      end

      it 'returns true' do
        expect(subject.add('strip_token')).to be_truthy
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
        create :subscriber_item, subscriber: subscriber
        subscriber.update stripe_customer_id: 'test_customer_sub'
        customer = Stripe::Customer.create(id: subscriber.stripe_customer_id, card: 'tk')
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
      subscriber.update stripe_customer_id: 'test_customer_sub'
      customer = Stripe::Customer.create(id: subscriber.stripe_customer_id, card: 'tk')
      customer.subscriptions.create({ :plan => 'weekly-bread-1' })
      create :subscriber_item, subscriber: subscriber
    end

    it 'marks all subscriber_items as paid' do
      expect(subject).to receive(:mark_subscriber_items_payment_as).once
      subject.update
    end

  end
end
