class StripeAPI
  include Stripe::Callbacks

  after_customer_subscription_deleted! do |subscription, event|
    stripe_customer_id = subscription.customer

    subscriber = Subscriber.find_by_stripe_customer_id stripe_customer_id

    subscriber.mark_subscriber_items_payment_as false
    subscriber.save!

    SubscriberNotifier.new(subscriber).sub_deleted
  end

  after_invoice_created! do |invoice, event|
    stripe_customer_id = invoice.customer

    subscriber = Subscriber.find_by_stripe_customer_id stripe_customer_id

    formatted_invoice = Invoice.new(invoice)

    SubscriberNotifier.new(subscriber, formatted_invoice).stripe_invoice
  end

  after_charge_dispute_created! do |charge, event|
    stripe_dispute(charge)
  end

end
