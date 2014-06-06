describe Sub do
  subject { Sub.new(subscriber)}

  describe '#add' do
    let(:subscriber) { create :subscriber }
    let(:stripe_customer) { double(id: "customer_id") }

    context 'with no current sub' do

      before do
        create :subscriber_item, subscriber: subscriber
        Stripe::Customer.stub(:create).and_return(stripe_customer)
        Notifier.stub(:new_sub)
      end

      it 'sends an new_sub email' do
        expect(Notifier).to receive(:new_sub)
        subject.add('strip_token')
      end

      it 'sets the subscriber\'s stripe id and active sub' do
        subject.add('stripe_token')

        expect(subscriber.stripe_customer_id).to eq('customer_id')
        expect(subscriber.num_paid_subs).to eq(1)
      end

      it 'returns true' do
        expect(subject.add('strip_token')).to be_true
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
        expect(subject.add('strip_token')).to be_false
      end
    end
  end

  describe '#cancel' do
    let(:subscriber) { create :subscriber, :paid }
    context 'happy path' do
      let(:stripe_customer) { double(cancel_subscription: true) }

      before do
        Stripe::Customer.stub(:retrieve).and_return(stripe_customer)
      end

      it 'updates num_paid_subs to nil' do
        expect(subscriber.num_paid_subs).to_not be_nil
        subject.cancel
        expect(subscriber.num_paid_subs).to be_nil
      end

      it 'returns true' do
        expect(subject.cancel).to be_true
      end
    end
  end
end
