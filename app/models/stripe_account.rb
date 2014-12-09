class StripeAccount < ActiveRecord::Base
  belongs_to :subscriber

  MONTHLY_COST_PENCE = 1000.freeze
  WEEKLY_COST_PENCE = MONTHLY_COST_PENCE/4.0.freeze

  validates :exp_year, :exp_month, :customer_id, :last4, presence: true

  def self.refund_holidays
    Holiday.in_last_week.each do |hol|
      stripe = hol.subscriber.stripe_account
      stripe.refund_weeks hol.will_miss
    end
  end

  def cancel(notifier = default_notifier)
    stripe_customer.subscriptions.each { |s| s.delete() }

    subscriber.mark_subscriptions_payment_as false
    notifier.sub_deleted

    true
  rescue Stripe::APIError => e
    Rails.logger.error "Stripe Authentication error while cancelling subscriber: #{e.message}"

    false
  end

  def update_stripe
    if stripe_subscription = stripe_customer.subscriptions.first
      stripe_subscription.plan = plan
      if stripe_subscription.save
        subscriber.mark_subscriptions_payment_as true
        return
      end
    end
    raise ActiveRecord::Rollback, 'Stripe Customer could not be updated'
  end

  def add(stripe_token)
    if new_stripe_customer = add_stripe_plan(stripe_token)

      card = new_stripe_customer.cards.data[0]

      update(customer_id: new_stripe_customer.id,
             last4: card.last4, exp_month: card.exp_month,
             exp_year: card.exp_year)

      subscriber.mark_subscriptions_payment_as true

      true
    else
      errors.add :base, "Our system is temporarily unable to process credit cards."
      false
    end
  end

  def refund_weeks(weeks)
    amount_to_refund = (weeks * WEEKLY_COST_PENCE * subscriber.num_paid_subs).to_i
    last_charges((weeks/4.0).ceil).each do |charge|
      if charge.amount < amount_to_refund
        charge.refund amount: charge.amount
        amount_to_refund -= charge.amount
      else
        charge.refund amount: amount_to_refund
        return
      end
    end
  end

  private

  def add_stripe_plan(stripe_token)
    Stripe::Customer.create(
      email: subscriber.email,
      card:  stripe_token,
      plan:  plan,
    )
  rescue Stripe::APIError => e
    Rails.logger.error "Stripe Authentication error while creating user: #{e.message}"
    false
  end

  def plan
    "weekly-bread-#{subscriber.subscriptions.size}"
  end

  def stripe_customer
    stripe_customer ||= Stripe::Customer.retrieve(customer_id)
  end

  def last_charges(nth = 1)
    sc = Stripe::Charge.all(customer: customer_id, count: nth)
    return sc if Rails.env.test?
    return sc['data'] if sc
    nil
  end

  def default_notifier
    SubscriberNotifier.new(subscriber)
  end
end
