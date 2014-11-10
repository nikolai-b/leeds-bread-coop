class BreadTypesController < ApplicationController
  before_action :set_bread_type, only: [:show, :edit, :update, :destroy]

  # GET /bread_types
  # GET /bread_types.json
  def index
    @bread_types = BreadType.paginate(page: params[:page])
  end

  # GET /bread_types/1
  # GET /bread_types/1.json
  def show
  end

  # GET /bread_types/new
  def new
    @bread_type = BreadType.new
  end

  # GET /bread_types/1/edit
  def edit
  end

  # POST /bread_types
  # POST /bread_types.json
  def create
    @bread_type = BreadType.new(bread_type_params)

    respond_to do |format|
      if @bread_type.save
        format.html { redirect_to @bread_type, notice: 'Bread type was successfully created.' }
        format.json { render :show, status: :created, location: @bread_type }
      else
        format.html { render :new }
        format.json { render json: @bread_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bread_types/1
  # PATCH/PUT /bread_types/1.json
  def update
    respond_to do |format|
      if @bread_type.update(bread_type_params)
        format.html { redirect_to @bread_type, notice: 'Bread type was successfully updated.' }
        format.json { render :show, status: :ok, location: @bread_type }
      else
        format.html { render :edit }
        format.json { render json: @bread_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bread_types/1
  # DELETE /bread_types/1.json
  def destroy
    @bread_type.destroy
    respond_to do |format|
      format.html { redirect_to bread_types_url, notice: 'Bread type was successfully destroyed.' }
      format.json { head :no_content }
    end
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
