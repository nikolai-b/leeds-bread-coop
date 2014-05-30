class SubsController < ApplicationController
  before_action :set_subscriber

  def new
  end

  def create
    customer = Stripe::Customer.create(
      :email => @subscriber.email,
      :card  => params[:stripeToken],
      :plan        => 'weekly-bread',
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to subscriptions_path
  end

  private

  def set_subscriber
    @subscriber = Subscriber.find params[:subscriber_id]
  end
end
