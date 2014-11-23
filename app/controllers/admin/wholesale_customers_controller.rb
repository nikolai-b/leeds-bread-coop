class Admin::WholesaleCustomersController < AdminController
  before_action :set_wholesale_customer, only: [:show, :edit, :update, :destroy]

  # GET /wholesale_customers
  # GET /wholesale_customers.json
  def index
    @wholesale_customers = WholesaleCustomer.all
  end

  # GET /wholesale_customers/1
  # GET /wholesale_customers/1.json
  def show
  end

  # GET /wholesale_customers/new
  def new
    @wholesale_customer = WholesaleCustomer.new
  end

  # GET /wholesale_customers/1/edit
  def edit
  end

  # POST /wholesale_customers
  # POST /wholesale_customers.json
  def create
    @wholesale_customer = WholesaleCustomer.new(wholesale_customer_params)

    respond_to do |format|
      if @wholesale_customer.save
        format.html { redirect_to @wholesale_customer, notice: 'Wholesale customer was successfully created.' }
        format.json { render :show, status: :created, location: @wholesale_customer }
      else
        format.html { render :new }
        format.json { render json: @wholesale_customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wholesale_customers/1
  # PATCH/PUT /wholesale_customers/1.json
  def update
    respond_to do |format|
      if @wholesale_customer.update(wholesale_customer_params)
        format.html { redirect_to @wholesale_customer, notice: 'Wholesale customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @wholesale_customer }
      else
        format.html { render :edit }
        format.json { render json: @wholesale_customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wholesale_customers/1
  # DELETE /wholesale_customers/1.json
  def destroy
    @wholesale_customer.destroy
    respond_to do |format|
      format.html { redirect_to wholesale_customers_url, notice: 'Wholesale customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wholesale_customer
      @wholesale_customer = WholesaleCustomer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wholesale_customer_params
      params.require(:wholesale_customer).permit(:name, :address, :phone, :opening_time, :delivery_receipt)
    end
end
