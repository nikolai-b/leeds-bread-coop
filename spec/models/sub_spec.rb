describe Sub do
  subject { Sub.new(subscriber)}

  describe '#add' do
    context 'with no current sub' do
      let(:subscriber) { create :subscriber }
      let(:stripe_customer) { double(id: "customer_id") }


      before do
        create :subscriber_item, subscriber: subscriber
        Stripe::Customer.stub(:create).and_return(stripe_customer)
        Notifier.stub(:new_sub)
      end

      it 'sends an new_sub email' do
        expect(Notifier).to receive(:new_sub)
        subject.add('strip_token')
      end

      it 'sets the subscriber\'s stripe id' do
        subject.add('stripe_token')
        expect(subscriber.stripe_customer_id).to eq('customer_id')
      end
    end
  end
end
