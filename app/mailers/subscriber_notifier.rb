class SubscriberNotifier
  require 'mustache'

  def initialize(subscriber, invoice = nil, emailer = Emailer)
    @subscriber, @invoice, @emailer = subscriber, invoice, emailer
  end

  def new_sub
    template = EmailTemplate.find_by name: 'new_sub'
    @emailer.send_mail(to: @subscriber.email,
         subject: 'New Subscription to Leeds Bread Co-op',
         body: Mustache.render( template.body, subscriber_details),
         content_type: 'text/html; charset=UTF-8')
  end

  def stripe_invoice
    template = EmailTemplate.find_by name: 'stripe_invoice'
    @emailer.send_mail(to: @subscriber.email,
         subject: 'Leeds Bread Co-op: Invoice',
         body: Mustache.render( template.body, subscriber_details.merge(invoice: invoice) ),
         content_type: 'text/html; charset=UTF-8')
  end

  def sub_deleted
    template = EmailTemplate.find_by name: 'sub_deleted'
    @emailer.send_mail(to: @subscriber.email,
                       cc: 'info@leedsbread.coop',
                       subject: 'Leeds Bread Co-op: Subscription Removed',
                       body: Mustache.render( template.body, subscriber_details),
                       content_type: 'text/html; charset=UTF-8')
  end

  def stripe_dispute(charge)
    @emailer.send_mail(to: "info@leedsbread.coop",
                 subject: "Stripe Dispute!",
                 body: "Someone is disputing a payment on Stipe, best log into the Stipe account to find out more -\n #{charge}")
  end


  private

  def subscriber_details
    {
      subscriber: @subscriber,
      bread_types: @subscriber.bread_types.map(&:name).to_sentence,
      collection_point: @subscriber.collection_point
    }
  end
end
