class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_subscriber!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(*allowed_subscriber_params)
    devise_parameter_sanitizer.for(:account_update).push(*allowed_subscriber_params)
  end

  def authenticate_admin
    unless current_subscriber.try :admin?
      redirect_to(root_path, alert: "You need to be in Leeds Bread Co-op to see that page")
      return
    end
  end

  def allowed_subscriber_params
    [:first_name, :last_name, :address, :phone, :collection_point_id, :quantity,
     subscriptions_attributes: allowed_subscription_params]
  end

  def allowed_subscription_params
    [:bread_type_id, :collection_day, :next_bread_type_id, :next_collection_day, :id, :_destroy]
  end

end
