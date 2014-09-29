class StripeSubsController < ApplicationController
  before_action :set_sub
  skip_before_action :authenticate_admin

  def edit
  end

  def create
    if @sub.add(params[:stripeToken])
      redirect_to current_subscriber
    else
      add_error_message
      render :edit
    end
  end

  def destroy
    if @sub.cancel
      redirect_to edit_subscriber_registration
    else
      add_error_message
      render :edit
    end
  end

  private

  def set_sub
    @sub = Sub.new(current_subscriber)
  end

  def add_error_message
    flash[:error] = "Something went wrong, please email (info@leedsbread.coop) or call us (0113 262 5155) if this continues"

    if @sub.errors.any?
      flash[:warn] = @sub.errors.full_messages.to_sentence
    end
  end
end
