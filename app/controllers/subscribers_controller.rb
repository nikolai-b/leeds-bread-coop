class SubscribersController < ApplicationController
  before_action :set_subscriber, only: [:show, :edit, :update, :destroy]
  def show
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_subscriber
    @subscriber = current_subscriber
  end
end
