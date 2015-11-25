describe StripeApi do
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
      StripeMock.mock_webhook_event(
        'invoice.created',
        {customer: subscriber.stripe_account.customer_id})['data']['object'], 'invoice.created')
  end

  it 'marks paid till on invoice payment succeeded' do
    subscriber.subscriptions.update_all paid_till: nil
    described_class.after_invoice_payment_succeeded(
      StripeMock.mock_webhook_event(
        'invoice.payment_succeeded',
        {customer: subscriber.stripe_account.customer_id})['data']['object'], 'invoice.payment_succeeded'
    )
    expect(subscriber.reload.subscriptions.first.paid_till).to eq(4.weeks.from_now.to_date)
  end

  it 'marks payments as false if customer subscription is deleted' do
    expect(notifier).to receive(:sub_deleted)

    described_class.after_customer_subscription_deleted(
      StripeMock.mock_webhook_event('customer.subscription.deleted', {customer: subscriber.stripe_account.customer_id})['data']['object'], 'subscriber.subscription.deleted')
    expect(subscriber.reload.subscriptions[0].paid_till).to be_falsey
  end

end
