class CopyRegularOrdersController < ApplicationController
  skip_before_action :authenticate_subscriber!, only: [:new]
  skip_before_action :authenticate_admin, only: [:new]

  def new
    if CopyRegularOrder.new.perform == 0
      head :no_content
    else
      render json: {errors: ""}, status: :unprocessable_entity
    end
  end
end
