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
           bread_type: subscriber.bread_type.name,
           collection_point: subscriber.collection_point
         ),
         content_type: 'text/html; charset=UTF-8')
    email.deliver
  end

  after_invoice_created! do |invoice, event|
    stripe_customer_id = invoice.customer

    subscriber = Subscriber.find_by_stripe_customer_id stripe_customer_id

    stripe_invoice(
      subscriber,
      {
        period_start: invoice.period_start,
        period_end: invoice.period_end,
        next_payment_attempt: invoice.next_payment_attempt,
        total: invoice.total
      })
  end

  after_charge_dispute_created! do |charge, event|
    stripe_customer_id = charge.customer
    subscriber = Subscriber.find_by_stripe_customer_id stripe_customer_id

    stripe_dispute(subscriber)
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

  def stripe_dispute(subscriber)
    email = mail(to: "info@leedsbread.coop",
                 subject: "Stripe Dispute!",
                 body: "#{subscriber.name} : #{subscriber.email} is disputing a payment on Stipe, best log into the Stipe account to find out more"
                )
  end
end
