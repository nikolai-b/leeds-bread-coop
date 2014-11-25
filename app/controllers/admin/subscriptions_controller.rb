class Admin::SubscriptionsController < Admin::BaseController
  skip_before_action :authenticate_admin
  before_action :set_stripe_sub, only: :update_all
  before_action :set_subscriber, only: :edit_all

  def index
  end


  def destroy
  end

  private

  def set_subscriber
    @subscriber = current_subscriber.admin? ? Subscriber.find(params[:admin_subscriber_id]) : current_subscriber
  end

  def set_stripe_sub
    @stripe_sub = current_subscriber.admin? ? StripeSub.new(Subscriber.find(params[:admin_subscriber_id])) : StripeSub.new(current_subscriber)
  end
end
