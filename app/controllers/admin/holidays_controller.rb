class Admin::HolidaysController < Admin::BaseController
  before_action :set_subscriber
  before_action :set_holiday, only: [:show, :edit, :update, :destroy]

  def index
    @holidays = @subscriber.holidays
  end

  def show
  end

  def new
    @holiday = Holiday.new
  end

  def edit
  end

  def create
    @holiday = Holiday.new(holiday_params.merge(subscriber: @subscriber))

    if @holiday.save_as_admin
      if @holiday.valid?
        redirect_to [:admin, @subscriber, @holiday], notice: 'Holiday was successfully created.'
      else
        redirect_to [:admin, @subscriber, @holiday], flash: {warning: "Holiday created with warning: #{@holiday.errors.full_messages.join}"}
      end
    else
      render :new
    end
  end

  def update
    if @holiday.update_as_admin(holiday_params)
      if @holiday.valid?
        redirect_to [:admin, @subscriber, @holiday], notice: 'Holiday was successfully updated.'
      else
        redirect_to [:admin, @subscriber, @holiday], flash: {warning: "Holiday updated with warning: #{@holiday.errors.full_messages.join}"}
      end
    else
      render :edit
    end
  end

  def destroy
    @holiday.destroy
    redirect_to admin_subscriber_holidays_url(@subscriber), notice: 'Holiday was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_holiday
      @holiday = Holiday.find(params[:id])
    end

    def set_subscriber
      @subscriber = Subscriber.find(params[:subscriber_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def holiday_params
      params.require(:holiday).permit(:start_date, :end_date, :subscriber_id)
    end
end
