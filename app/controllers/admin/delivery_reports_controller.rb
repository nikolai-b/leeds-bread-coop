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
    @delivery_report = DeliveryReport.new(Date.parse(params[:date]))
  end
end
