class StripeSubsController < ApplicationController
  before_action :set_stripe_sub
  skip_before_action :authenticate_admin

  def edit
  end

  def create
    if @stripe_sub.add(params[:stripeToken])
      SubscriberNotifier.new(current_subscriber).new_sub
      flash[:notice] = "Montly Payment Plan created"
      redirect_to current_subscriber
    else
      add_error_message
      render :edit
    end
  end

  def update
    if @stripe_sub.add(params[:stripeToken])
      flash[:notice] = "Payment Card updated"
      redirect_to current_subscriber
    else
      add_error_message
      render :edit
    end
  end

  def destroy
    if @stripe_sub.cancel
      redirect_to edit_subscriber_registration
    else
      add_error_message
      render :edit
    end
  end

  private

  def set_stripe_sub
    @stripe_sub = StripeSub.new(current_subscriber)
  end

  def add_error_message
    flash[:error] = "Something went wrong, please email (info@leedsbread.coop) or call us (0113 262 5155) if this continues"

    if @stripe_sub.errors.any?
      flash[:warn] = @stripe_sub.errors.full_messages.to_sentence
    end
  end
end
