class SubscriptionsController < ApplicationController
  skip_before_action :authenticate_admin

  def index
  end

  def edit_all
  end

  def update_all
    if current_subscriber.update bread_subscriptions_params
      current_subscriber.save
      current_subscriber.mark_subscriptions_payment_as true

      redirect_to current_subscriber, notice: 'Bread subscription was successfully updated'
    else
      render :edit_all
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def bread_subscriptions_params
    params.require(:subscriptions).permit(allowed_subscriber_parms)
  end
end
