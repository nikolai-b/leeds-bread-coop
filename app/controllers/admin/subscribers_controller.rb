class Admin::SubscribersController < Admin::BaseController
  before_action :set_subscriber, only: [:edit_all, :update_all, :show, :edit, :update, :destroy]
  skip_before_action :authenticate_admin, only: [:show]
  has_scope :pays_with
  has_scope :search
  has_scope :paid_till_order, type: :boolean

  def index
    respond_to do |format|
      format.html { @subscribers = apply_scopes(Subscriber.ordered.not_admin.paginate(:page => params[:page])) }
      format.csv { send_data Subscriber.to_csv }
    end
  end

  def new
    @subscriber = Subscriber.new
  end

  def show
  end

  def edit
  end

  def create
    @subscriber = Subscriber.new subscriber_params

    if @subscriber.save
      redirect_to [:admin, @subscriber], notice: 'Subscriber was successfully created.'
    else
      render :new
    end
  end

  def update
    update_params = subscriber_params
    update_params.delete :password if update_params[:password] == '' || !update_params[:password]

    if @subscriber.update(update_params)
      redirect_to [:admin, @subscriber], notice: 'Subscriber was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @subscriber.destroy
    redirect_to admin_subscribers_url, notice: 'Subscriber was successfully deleted.'
  end

  def import
    if params[:file]
      Subscriber.import(params[:file])
      redirect_to admin_subscribers_url, notice: "Subscribers imported!"
    else
      redirect_to admin_subscribers_url, flash: {warning: "No file attached"}
    end
  rescue Subscriber::ImportError => e
    redirect_to admin_subscribers_url, flash: {error: e.message}
  end

  private

  def set_subscriber
    @subscriber = Subscriber.find(params[:subscriber_id] || params[:id])
  end

  def subscriber_params
    params.require(:subscriber).permit(allowed_subscriber_params)
  end
end
