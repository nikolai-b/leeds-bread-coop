class Admin::SubscriptionsController < AdminController
  skip_before_action :authenticate_admin
  before_action :set_stripe_sub, only: :update_all
  before_action :set_subscriber, only: :edit_all

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

  def destroy
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def bread_subscriptions_params
    params.require(:subscriptions).permit(allowed_subscriber_parms)
  end

  def set_subscriber
    @subscriber = current_subscriber.admin? ? Subscriber.find(params[:admin_subscriber_id]) : current_subscriber
  end

  def set_stripe_sub
    @stripe_sub = current_subscriber.admin? ? StripeSub.new(Subscriber.find(params[:admin_subscriber_id])) : StripeSub.new(current_subscriber)
  end
end
