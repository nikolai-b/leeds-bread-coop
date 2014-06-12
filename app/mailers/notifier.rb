class Notifier < ActionMailer::Base
  default from: "info@leedsbread.coop"
  require 'mustache'
  include Stripe::Callbacks

  def new_sub(subscriber)
    template = EmailTemplate.find_by name: 'new_sub'
    email = mail(to: subscriber.email,
         subject: 'New Subscription to Leeds Bread Co-op',
         body: Mustache.render(
           template.body,
           subscriber: subscriber,
           bread_types: subscriber.bread_types.map {|b| b.name },
           collection_point: subscriber.collection_point
         ),
         content_type: 'text/html; charset=UTF-8')
    email.deliver
  end

  after_customer_subscription_deleted! do |subscription, event|
    stripe_customer_id = subscription.customer

    subscriber = Subscriber.find_by_stripe_customer_id stripe_customer_id

    subscriber.mark_subscriber_items_payment_as false
    subscriber.save!

    Notifier.sub_deleted(subscriber)
  end

  after_invoice_created! do |invoice, event|
    stripe_customer_id = invoice.customer


    subscriber = Subscriber.find_by_stripe_customer_id stripe_customer_id


    formatted_invoice = Invoice.new(invoice )

    stripe_invoice(subscriber, formatted_invoice)
  end

  after_charge_dispute_created! do |charge, event|
    stripe_dispute(charge)
  end

  def stripe_invoice(subscriber, invoice)
    template = EmailTemplate.find_by name: 'stripe_invoice'
    email = mail(to: subscriber.email,
         subject: 'Leeds Bread Co-op Invoice',
         body: Mustache.render(
           template.body,
           subscriber: subscriber,
           bread_type: subscriber.bread_type.name,
           collection_point: subscriber.collection_point,
           invoice: invoice
         ),
         content_type: 'text/html; charset=UTF-8')
    email.deliver
  end

  def sub_deleted(subscriber)
    template = EmailTemplate.find_by name: 'sub_deleted'
    email = mail(to: subscriber.email,
         subject: 'Leeds Bread Co-op Invoice',
         body: Mustache.render(
           template.body,
           subscriber: subscriber,
           bread_type: subscriber.bread_type.name,
           collection_point: subscriber.collection_point,
           invoice: invoice
         ),
         content_type: 'text/html; charset=UTF-8')
    email.deliver
  end

  def stripe_dispute(charge)
    email = mail(to: "info@leedsbread.coop",
                 subject: "Stripe Dispute!",
                 body: "Someone is disputing a payment on Stipe, best log into the Stipe account to find out more -\n #{charge}"
                )
    email.deliver
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
