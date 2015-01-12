class Admin::CollectionPointsController < Admin::BaseController
  before_action :set_collection_point, only: [:show, :edit, :update, :destroy]

  def index
    @collection_points = CollectionPoint.all.ordered
  end

  def show
  end

  def new
    @collection_point = CollectionPoint.new
  end

  def edit
  end

  def create
    @collection_point = CollectionPoint.new(collection_point_params)

    if @collection_point.save
      redirect_to [:admin, @collection_point], notice: 'Collection point was successfully created.'
    else
      render :new
    end
  end

  def update
    if @collection_point.update(collection_point_params)
      redirect_to [:admin, @collection_point], notice: 'Collection point was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @collection_point.destroy
    redirect_to admin_collection_points_url, notice: 'Collection point was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection_point
      @collection_point = CollectionPoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_point_params
      params.require(:collection_point).permit(:address, :post_code, :notes, :name, valid_days: [])
    end
end
