class StripeApi
  include Stripe::Callbacks

  after_customer_subscription_deleted! do |stripe_data, event|
    after_customer_subscription_deleted(stripe_data, event)
  end

  after_invoice_created! do |stripe_data, event|
    after_invoice_created(stripe_data, event)
  end

  after_charge_dispute_created! do |charge, event|
    SubscriberNotifier.stripe_dispute(charge)
  end

  after_invoice_payment_succeeded! do |charge, event|
    after_invoice_payment_succeeded(charge, event)
  end

  class << self
    def after_customer_subscription_deleted(stripe_data, event)
      if subscriber = retrieve_subsciber(stripe_data)
        subscriber.subscriptions.update_all(paid_till: nil)
        SubscriberNotifier.new(subscriber).sub_deleted
      end
    end

    def after_invoice_created(stripe_data, event)
      if subscriber = retrieve_subsciber(stripe_data)
        invoice = StripeApi::Invoice.new(stripe_data)
        SubscriberNotifier.new(subscriber, invoice).stripe_invoice
      end
    end

    def after_invoice_payment_succeeded(stripe_data, event)
      if subscriber = retrieve_subsciber(stripe_data)
        subscriber.subscriptions.update_all paid_till: 4.weeks.from_now
      end
    end

    private

    def retrieve_subsciber(stripe_data)
      stripe_account = StripeAccount.find_by_customer_id stripe_data.customer
      stripe_account.try :subscriber
    end
  end

end
