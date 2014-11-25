class Admin::ProductionReportsController < Admin::BaseController
  def show
    @production_report = ProductionReport.new(Date.parse(params[:date]))
  end
end

