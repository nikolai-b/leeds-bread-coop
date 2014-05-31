class EmailTemplatesController < ApplicationController
  before_action :set_email_template, only: [:show, :edit, :update, :destroy]

  # GET /email_templates
  # GET /email_templates.json
  def index
    @email_templates = EmailTemplate.all
  end

  # GET /email_templates/1
  # GET /email_templates/1.json
  def show
  end

  # GET /email_templates/1/edit
  def edit
  end


  # PATCH/PUT /email_templates/1
  # PATCH/PUT /email_templates/1.json
  def update
    respond_to do |format|
      if @email_template.update(email_template_params)
        format.html { redirect_to @email_template, notice: 'Email template was successfully updated.' }
        format.json { render :show, status: :ok, location: @email_template }
      else
        format.html { render :edit }
        format.json { render json: @email_template.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_template
      @email_template = EmailTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_template_params
      params.require(:email_template).permit(:name, :body)
    end
end
