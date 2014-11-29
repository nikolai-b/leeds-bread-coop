class Admin::BreadTypesController < Admin::BaseController
  before_action :set_bread_type, only: [:show, :edit, :update, :destroy]

  def index
    @bread_types = BreadType.paginate(page: params[:page])
  end

  def show
  end

  def new
    @bread_type = BreadType.new
  end

  def edit
  end

  def create
    @bread_type = BreadType.new(bread_type_params)

    if @bread_type.save
      redirect_to [:admin, @bread_type], notice: 'Bread type was successfully created.'
    else
      render :new
    end
  end

  def update
    if @bread_type.update(bread_type_params)
      redirect_to [:admin, @bread_type], notice: 'Bread type was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @bread_type.destroy
    redirect_to [:admin, bread_types_url], notice: 'Bread type was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bread_type
      @bread_type = BreadType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bread_type_params
      params.require(:bread_type).permit(:name, :sour_dough, :notes, :wholesale_only)
    end
end
