class Admin::DeliveryReportsController < Admin::BaseController
  before_action :set_delivery_report, only: :show

  def show
    respond_to do |format|
      format.html
      format.csv {send_data @delivery_report.to_csv}
    end
  end

  private

  def set_delivery_report
    @delivery_report = DeliveryReport.new(parsed_date)
  end

  def parsed_date
    params[:date].present? ? Date.parse(params[:date]) : Date.current
  end
end
