class CopyRegularOrdersController < ApplicationController
  skip_before_action :authenticate_subscriber!, only: [:new]
  skip_before_action :authenticate_admin, only: [:new]

  def new
    CopyRegularOrder.perform
    head :no_content
  end
end
