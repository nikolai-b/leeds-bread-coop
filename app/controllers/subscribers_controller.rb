class SubscribersController < ApplicationController
  before_action :set_subscriber, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_admin, only: [:show]

  # GET /subscribers
  # GET /subscribers.json
  def index
    @subscribers = Subscriber.ordered.paginate(:page => params[:page])
  end

  def new
    @subscriber = Subscriber.new
  end

  # GET /subscribers/1
  # GET /subscribers/1.json
  def show
  end

  # GET /subscribers/1/edit
  def edit
  end

  # POST /subscribers
  # POST /subscribers.json
  def create
    @subscriber = Subscriber.new(subscriber_params)

    respond_to do |format|
      if @subscriber.save
        format.html { redirect_to @subscriber, notice: 'Subscriber was successfully created.' }
        format.json { render :show, status: :created, location: @subscriber }
      else
        format.html { render :new }
        format.json { render json: @subscriber.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subscribers/1
  # PATCH/PUT /subscribers/1.json
  def update
    respond_to do |format|
      update_params = subscriber_params
      if update_params[:password] == '' || !update_params[:password]
        update_params.delete :password
      end

      if @subscriber.update(update_params)
        format.html { redirect_to @subscriber, notice: 'Subscriber was successfully updated.' }
        format.json { render :show, status: :ok, location: @subscriber }
      else
        format.html { render :edit }
        format.json { render json: @subscriber.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subscribers/1
  # DELETE /subscribers/1.json
  def destroy
    @subscriber.destroy
    respond_to do |format|
      format.html { redirect_to subscribers_url, notice: 'Subscriber was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    if params[:file]
      Subscriber.import(params[:file])
      redirect_to admin_subscriber_index_path, notice: "Subscribers imported!"
    else
      redirect_to admin_subscriber_index_path, notice: "No file attached"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscriber
      @subscriber = current_subscriber.admin? ? Subscriber.find(params[:id]) : current_subscriber
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def subscriber_params
      params.require(:subscriber).permit(*add_paid_to_subscriptions)
    end

    def add_paid_to_subscriptions
      allowed = allowed_subscriber_parms.dup + [:email, :password]
      allowed.find{ |i| i.class == Hash && i.keys.include?(:subscriptions_attributes) }[:subscriptions_attributes] << :paid
      allowed
    end
end
