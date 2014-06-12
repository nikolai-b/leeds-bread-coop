class HolidayController < ApplicationController
  skip_before_action :authenticate_admin
  before_action :set_subscriber

  def new
    @subscriber = current_subscriber
  end

  def create
    HolidayEmail.send_this(holiday_params)
    flash[:notice] = "We have been notified about your subscription holiday, thanks!"
    redirect_to @subscriber
  end

  private

  def set_subscriber
    @subscriber = current_subscriber
  end

  def holiday_params
    attrs = {}
    attrs[:subscriber_name] = @subscriber.name
    attrs[:subscriber_path] = subscribers_url(@subscriber)
    attrs[:from_date] = params[:from_date]
    attrs[:to_date] = params[:to_date]
    attrs
  end

end
