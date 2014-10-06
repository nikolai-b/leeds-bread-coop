class SubscriberItemsController < ApplicationController
  skip_before_action :authenticate_admin
  before_action :set_stripe_sub, only: :update_all

  def index
  end

  def edit_all
  end

  def update_all
    if current_subscriber.update subscriber_items_params
      if @stripe_sub.update
        redirect_to current_subscriber, notice: 'Order was successfully updated.'
      else
        render :edit_all, notice: 'Problem with our payment service, please try again'
      end
    else
      render :edit_all
    end
  end

  def destroy
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def subscriber_items_params
    params.require(:subscriber_items).permit(allowed_subscriber_parms)
  end

  def set_stripe_sub
    @stripe_sub = StripeSub.new(current_subscriber)
  end
end
