class ProductionReportsController < ApplicationController
  def show
    @production_report = ProductionReport.new(Date.parse(params[:date]))
  end
end

