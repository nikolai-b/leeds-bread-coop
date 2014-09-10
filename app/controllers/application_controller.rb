class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_subscriber!
  before_action :authenticate_admin, unless: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(*allowed_subscriuber_parms)
    devise_parameter_sanitizer.for(:account_update).push(*allowed_subscriuber_parms)
  end

  def authenticate_admin
    unless current_subscriber.try(:admin?)
      redirect_to(root_path, :alert => "You need to be in Leeds Bread Co-op to see that page")
      return
    end
  end

  def allowed_subscriuber_parms
    [:first_name, :last_name, :address, :phone, :collection_point_id, :quantity, :notes, subscriber_items_attributes: [:bread_type_id, :collection_day, :id, :_destroy] ]
  end

end
