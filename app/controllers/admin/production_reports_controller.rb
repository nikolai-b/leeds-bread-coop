class Admin::ProductionReportsController < AdminController
  def show
    @production_report = ProductionReport.new(Date.parse(params[:date]))
  end
end

