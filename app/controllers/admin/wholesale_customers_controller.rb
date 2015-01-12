class Admin::WholesaleCustomersController < Admin::BaseController
  before_action :set_wholesale_customer, only: [:show, :edit, :update, :destroy]

  def index
    @wholesale_customers = WholesaleCustomer.all.ordered
  end

  def show
  end

  def new
    @wholesale_customer = WholesaleCustomer.new
  end

  def edit
  end

  def create
    @wholesale_customer = WholesaleCustomer.new(wholesale_customer_params)
    if @wholesale_customer.save
      redirect_to [:admin, @wholesale_customer], notice: 'Wholesale customer was successfully created.'
    else
      render :new
    end
  end

  def update
    if @wholesale_customer.update(wholesale_customer_params)
      redirect_to [:admin, @wholesale_customer], notice: 'Wholesale customer was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @wholesale_customer.destroy
    redirect_to admin_wholesale_customers_url, notice: 'Wholesale customer was successfully destroyed.'
  end

  private
    def set_wholesale_customer
      @wholesale_customer = WholesaleCustomer.find(params[:id])
    end

    def wholesale_customer_params
      params.require(:wholesale_customer).permit(:name, :address, :phone, :opening_time, :delivery_receipt)
    end
end
