class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_wholesale_customer
  has_scope :future, type: :boolean, default: true

  def index
    @orders = apply_scopes(@wholesale_customer.orders.ordered.paginate(:page => params[:page]))
  end

  def show
  end

  def new
    @order = Order.new
  end

  def edit
  end

  def create
    @order = @wholesale_customer.orders.new(order_params)

    if @order.save(order_params)
      redirect_to [:admin, @wholesale_customer, @order], notice: 'Order was successfully created.'
    else
      render :new
    end
  end

  def update
    if @order.update(order_params)
      redirect_to [:admin, @wholesale_customer, @order], notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @order.destroy
    redirect_to admin_wholesale_customer_orders_url(@wholesale_customer), notice: 'Order was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:date, :sample, :regular, :note, line_items_attributes: [:id, :bread_type_id, :quantity, :_destroy])
    end

    def set_wholesale_customer
      @wholesale_customer = WholesaleCustomer.find(params[:wholesale_customer_id])
    end
end
