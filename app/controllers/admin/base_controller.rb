class Admin::BaseController < ApplicationController
  before_action :authenticate_admin

  protected

  def authenticate_admin
    unless current_subscriber.try(:admin?)
      redirect_to(root_path, :alert => "You need to be in Leeds Bread Co-op to see that page")
      return
    end
  end

  def allowed_subscriber_params
    super + [:email, :password, :notes]
  end

  def allowed_subscription_params
    super + [:paid_till]
  end
end
