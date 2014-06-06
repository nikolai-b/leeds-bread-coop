class Sub
  extend ActiveModel::Naming
  attr_reader :errors

  def initialize(subscriber)
    @subscriber = subscriber
    @errors = ActiveModel::Errors.new(self)
  end

  def cancel
    customer = Stripe::Customer.retrieve(@subscriber.stripe_customer_id)
    customer.cancel_subscription

    @subscriber.update_attributes(active_sub: nil)

    true
  rescue Stripe::APIError => e
    Rails.logger.error "Stripe Authentication error while cancelling subscriber: #{e.message}"

    false
  end

  def add(stripe_token)
    stripe_customer = add_stripe_plan(stripe_token)

    if stripe_customer
      Notifier.new_sub(@subscriber)

      @subscriber.update ({
        stripe_customer_id: stripe_customer.id,
        active_sub: @subscriber.bread_types.size
      })

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
