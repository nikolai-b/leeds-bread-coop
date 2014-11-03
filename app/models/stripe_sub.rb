class StripeSub
  extend ActiveModel::Naming
  attr_reader :errors
  MONTHLY_COST_PENCE = 1000.freeze

  def initialize(subscriber, notifier = nil)
    @subscriber = subscriber
    @notifier = notifier || SubscriberNotifier.new(subscriber)
    @errors = ActiveModel::Errors.new(self)
  end

  def cancel
    stripe_customer.subscriptions.each { |s| s.delete() }

    @subscriber.mark_subscriptions_payment_as false
    @notifier.sub_deleted

    true
  rescue Stripe::APIError => e
    Rails.logger.error "Stripe Authentication error while cancelling subscriber: #{e.message}"

    false
  end

  def update
    if stripe_subscription = stripe_customer.subscriptions.first
      stripe_subscription.plan = plan
      if stripe_subscription.save
        @subscriber.mark_subscriptions_payment_as true
        return
      end
    end
    raise ActiveRecord::Rollback, 'Stripe Customer could not be updated'
  end

  def add(stripe_token)
    if new_stripe_customer = add_stripe_plan(stripe_token)

      @subscriber.update(stripe_customer_id: new_stripe_customer.id)

      card = new_stripe_customer.cards.data[0]
      @subscriber.create_payment_card(last4: card.last4, exp_month: card.exp_month, exp_year: card.exp_year)
      @subscriber.mark_subscriptions_payment_as true

      true
    else
      errors.add :base, "Our system is temporarily unable to process credit cards."
      false
    end
  end

  def refund_weeks(weeks)
    amount = weeks * MONTHLY_COST_PENCE / 4.0
    full, remainder = amount.divmod MONTHLY_COST_PENCE
    charges = last_charges(full + 1)
    if charges
      charges[0..-2].each do |charge|
        charge.refund
      end
      charges[-1].refund amount: remainder
    end
  end

  private

  def add_stripe_plan(stripe_token)
    sc = Stripe::Customer.create(
      :email => @subscriber.email,
      :card  => stripe_token,
      :plan  => plan,
    )
  rescue Stripe::APIError => e
    Rails.logger.error "Stripe Authentication error while creating user: #{e.message}"
    false
  end

  def plan
    "weekly-bread-#{@subscriber.subscriptions.size}"
  end

  def stripe_customer
    stripe_customer ||= Stripe::Customer.retrieve(@subscriber.stripe_customer_id)
  end

  def last_charges(nth = 1)
    sc = Stripe::Charge.all(customer: @subscriber.stripe_customer_id, count: nth)
    return sc['data'] if sc
    nil
  end
end
