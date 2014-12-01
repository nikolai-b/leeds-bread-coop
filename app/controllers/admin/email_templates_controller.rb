class Admin::EmailTemplatesController < Admin::BaseController
  before_action :set_email_template, only: [:show, :edit, :update, :destroy]

  def index
    @email_templates = EmailTemplate.all
  end

  def show
  end

  def edit
  end

  def update
    if @email_template.update(email_template_params)
      redirect_to [:admin, @email_template], notice: 'Email template was successfully updated.'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_template
      @email_template = EmailTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_template_params
      params.require(:email_template).permit(:body)
    end
end
