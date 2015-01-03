class StripeSubsController < ApplicationController
  before_action :set_stripe_account
  skip_before_action :authenticate_admin

  def new
    if current_subscriber.stripe_account
      flash[:error] = 'You already have a payment card'
      render :edit
    end
  end

  def edit
    unless current_subscriber.stripe_account
      render :new
    end
  end

  def create
    if current_subscriber.create_stripe_account.add_token(params[:stripeToken])
      SubscriberNotifier.new(current_subscriber).new_sub
      flash[:notice] = "Montly Payment Plan created"
      redirect_to current_subscriber
    else
      add_error_message
      render :new
    end
  end

  def update
    if @stripe_account.add_token(params[:stripeToken])
      flash[:notice] = "Payment Card updated"
      redirect_to current_subscriber
    else
      add_error_message
      render :edit
    end
  end

  def destroy
    if @stripe_account.cancel
      redirect_to edit_subscriber_registration
    else
      add_error_message
      render :edit
    end
  end

  private

  def set_stripe_account
    @stripe_account = current_subscriber.stripe_account
  end

  def add_error_message
    flash[:error] = "Something went wrong, please email (info@leedsbread.coop) or call us (0113 262 5155) if this continues"

    if @stripe_account.errors.any?
      flash[:warn] = @stripe_account.errors.full_messages.to_sentence
    end
  end
end
