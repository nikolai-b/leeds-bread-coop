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

  def update
    stripe_customer = Stripe::Customer.retrieve(@subscriber.stripe_customer_id)

    if stripe_customer
      stripe_subscription = stripe_customer.subscriptions.retrieve(stripe_customer.subscriptions.data[0].id)
      stripe_subscription.plan = plan
      if stripe_subscription.save
        @subscriber.mark_subscriber_items_payment_as true
        return true
      end
    end

    false
  end

  def add(stripe_token)
    stripe_customer = add_stripe_plan(stripe_token)

    if stripe_customer

      @subscriber.update(stripe_customer_id: stripe_customer.id)

      card = stripe_customer.cards.data[0]
      @subscriber.create_payment_card(last4: card.last4, exp_month: card.exp_month, exp_year: card.exp_year)

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
      :plan  => plan,
    )

  rescue Stripe::APIError => e
    Rails.logger.error "Stripe Authentication error while creating user: #{e.message}"
    false
  end

  def plan
    "weekly-bread-#{@subscriber.subscriber_items.size}"
  end
end
