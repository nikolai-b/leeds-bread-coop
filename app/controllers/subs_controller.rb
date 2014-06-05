class SubsController < ApplicationController
  before_action :set_subscriber
  skip_before_action :authenticate_admin

  def new
  end

  def create
    begin
      customer = Stripe::Customer.create(
        :email => @subscriber.email,
        :card  => params[:stripeToken],
        :plan        => "weekly-bread-#{@subscriber.bread_types.size}",
      )

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to subscriptions_path
    end

    @subscriber.update ({stripe_customer_id: customer.id, active_sub: true} )

    Notifier.new_sub(@subscriber)

    redirect_to @subscriber
  end

  private

  def set_subscriber
    @subscriber = current_subscriber
  end
end
