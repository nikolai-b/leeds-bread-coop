class DeliveryReportsController < ApplicationController
  def show
    @delivery_report = DeliveryReport.new(Date.parse(params[:date])).show
  end
end
