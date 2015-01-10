describe StripeAPI do
  let!(:subscriber) { create :subscriber, :with_subscription }
  let(:notifier) { double 'notifier' }

  before do
    create :email_template, name: 'stripe_invoice'
    create :email_template, name: 'sub_deleted'
    allow(SubscriberNotifier).to receive(:new).and_return(notifier)
  end

  it 'sends stripe_invoice email on invoice created event' do
    expect(notifier).to receive(:stripe_invoice)

    described_class.after_invoice_created(
      StripeMock.mock_webhook_event('invoice.created', {customer: subscriber.stripe_account.customer_id})['data']['object'], 'invoice.created')
  end

  it 'marks payments as false if customer subscription is deleted' do
    expect(notifier).to receive(:sub_deleted)

    described_class.after_customer_subscription_deleted(
      StripeMock.mock_webhook_event('customer.subscription.deleted', {customer: subscriber.stripe_account.customer_id})['data']['object'], 'subscriber.subscription.deleted')
    expect(subscriber.reload.subscriptions[0].paid).to be_falsey
  end

end
