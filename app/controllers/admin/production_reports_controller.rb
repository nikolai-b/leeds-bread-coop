class Admin::ProductionReportsController < Admin::BaseController
  def show
    @production_report = ProductionReport.new(parsed_date)
  end

  private

  def parsed_date
    params[:date].present? ? Date.parse(params[:date]) : Date.current
  end

end

