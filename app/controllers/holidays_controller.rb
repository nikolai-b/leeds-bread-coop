class HolidaysController < ApplicationController
  before_action :set_subscriber
  before_action :set_holiday, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_admin, only: [:new, :create, :show, :index]

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

    if @holiday.save
      redirect_to [@subscriber, @holiday], notice: 'Holiday was successfully created.'
    else
      render :new
    end
  end

  def update
    if @holiday.update(holiday_params)
      redirect_to @holiday, notice: 'Holiday was successfully updated.'
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
