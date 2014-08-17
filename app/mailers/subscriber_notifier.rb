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
         subject: 'Leeds Bread Co-op: Subscription Removed',
         body: Mustache.render( template.body, subscriber_details),
         content_type: 'text/html; charset=UTF-8')
  end

  def stripe_dispute(charge)
    @emailer.send_mail(to: "info@leedsbread.coop",
                 subject: "Stripe Dispute!",
                 body: "Someone is disputing a payment on Stipe, best log into the Stipe account to find out more -\n #{charge}")
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

  private

  def subscriber_details
    {
      subscriber: @subscriber,
      bread_types: @subscriber.bread_types.map(&:name).to_sentence,
      collection_point: @subscriber.collection_point
    }
  end
end
