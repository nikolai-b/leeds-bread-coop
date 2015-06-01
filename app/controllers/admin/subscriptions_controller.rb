class Admin::SubscriptionsController < Admin::BaseController
  before_action :set_subscriber, only: [:edit_all, :update_all]

  def edit_all
  end

  def update_all
    if params[:subscriptions] && @subscriber.update(bread_subscriptions_params)
      @subscriber.save
      @subscriber.mark_subscriptions_payment_as true

      redirect_to [:admin, @subscriber], notice: 'Bread subscription was successfully updated'
    else
      render :edit_all
    end
  end

  private

  def set_subscriber
    @subscriber = Subscriber.find(params[:subscriber_id])
  end

  def bread_subscriptions_params
    params.require(:subscriptions).permit(allowed_subscriber_parms)
  end
end
