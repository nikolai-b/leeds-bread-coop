class StripeAPI
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

  class << self
    def after_customer_subscription_deleted(stripe_data, event)
      if subscriber = retrieve_subsciber(stripe_data)
        subscriber.mark_subscriptions_payment_as false
        subscriber.save!

        SubscriberNotifier.new(subscriber).sub_deleted
      end
    end

    def after_invoice_created(stripe_data, event)
      invoice = Invoice.new(stripe_data)
      subscriber = retrieve_subsciber(stripe_data)
      SubscriberNotifier.new(subscriber, invoice).stripe_invoice
    end

    private

    def retrieve_subsciber(stripe_data)
      stripe_account = StripeAccount.find_by_customer_id stripe_data.customer
      stripe_account.try :subscriber
    end
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
