class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_subscriber!
  before_action :authenticate_admin, unless: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:name, :address, :phone, :collection_point_id, :start_date, :bread_type_id, :quantity, :notes)
  end

  def authenticate_admin
    unless current_subscriber.try(:admin?)
      byebug
      params[:controller]
      redirect_to(root_path, :alert => "You need to be in Leeds Bread Co-op to see that page")
      return
    end
  end
end
