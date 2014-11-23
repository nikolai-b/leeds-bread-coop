class AdminController < ApplicationController
  before_action :authenticate_admin

  protected

  def authenticate_admin
    unless current_subscriber.try(:admin?)
      redirect_to(root_path, :alert => "You need to be in Leeds Bread Co-op to see that page")
      return
    end
  end
end
