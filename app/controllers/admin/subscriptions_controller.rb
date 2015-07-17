class Admin::SubscriptionsController < Admin::BaseController
  before_action :set_subscriber, only: [:edit_all, :update_all]

  def edit_all
  end

  def update_all
    if params[:subscriptions] && @subscriber.update(bread_params_with_admin)
      @subscriber.save
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
    params.require(:subscriptions).permit(allowed_subscriber_params)
  end

  def bread_params_with_admin
    bread_params_with_admin = bread_subscriptions_params.dup
    bread_params_with_admin[:subscriptions_attributes].each { |k, v| v.merge! as_admin: true } if bread_params_with_admin[:subscriptions_attributes]
    bread_params_with_admin
  end
end
