class StripeSub
  extend ActiveModel::Naming
  attr_reader :errors

  def initialize(subscriber, notifier = nil)
    @subscriber = subscriber
    @notifier = notifier || SubscriberNotifier.new(subscriber)
    @errors = ActiveModel::Errors.new(self)
  end

  def cancel
    customer = Stripe::Customer.retrieve(@subscriber.stripe_customer_id)
    customer.cancel_subscription

    @subscriber.mark_subscriber_items_payment_as false
    @notifier.sub_deleted

    true
  rescue Stripe::APIError => e
    Rails.logger.error "Stripe Authentication error while cancelling subscriber: #{e.message}"

    false
  end

  def add(stripe_token)
    stripe_customer = add_stripe_plan(stripe_token)

    if stripe_customer

      @subscriber.update ({ stripe_customer_id: stripe_customer.id })

      @subscriber.mark_subscriber_items_payment_as true

      @notifier.new_sub

      true
    else
      errors.add :base, "Our system is temporarily unable to process credit cards."
      false
    end
  end
  private

  def add_stripe_plan(stripe_token)
    Stripe::Customer.create(
      :email => @subscriber.email,
      :card  => stripe_token,
      :plan  => "weekly-bread-#{@subscriber.bread_types.size}",
    )

  rescue Stripe::APIError => e
    Rails.logger.error "Stripe Authentication error while creating user: #{e.message}"
    false
  end


end
