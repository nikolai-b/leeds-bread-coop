class StripeAPI
  include Stripe::Callbacks

  after_customer_subscription_deleted! do |subscription, event|
    stripe_customer_id = subscription.customer

    subscriber = Subscriber.find_by_stripe_customer_id stripe_customer_id

    if subscriber
      subscriber.mark_subscriptions_payment_as false
      subscriber.save!

      SubscriberNotifier.new(subscriber).sub_deleted
    end
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

  class Invoice
    def initialize(invoice)
      @invoice = invoice
    end

    def total
      (@invoice.total.to_f / 100.0).to_s
    end

    def amount_due
      (@invoice.amount_due.to_f / 100.0).to_s
    end

    def period_start
      Time.at(@invoice.lines.data[0].period.start).strftime("%d/%m/%Y") #maybe @invoice.period_start
    end

    def period_end
      Time.at(@invoice.lines.data[0].period.end).strftime("%d/%m/%Y") #maybe invoice.lines.data[0].period.end
    end

    def next_payment_attempt
      Time.at(next_payment_attempt_raw).strftime("%d/%m/%Y")
    end

    def next_payment_attempt_raw
      @invoice.next_payment_attempt || Time.new.to_i
    end
  end
end
