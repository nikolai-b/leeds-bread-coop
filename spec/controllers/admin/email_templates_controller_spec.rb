describe Admin::EmailTemplatesController, type: :controller do
  before do
    warden.set_user admin
  end
  let(:admin) { create :subscriber, :admin }
  let(:email_template) { create :email_template }

  describe 'routing' do
    it { is_expected.to route(:get,     '/admin/email_templates').to(action: :index) }
    it { is_expected.to route(:get,     '/admin/email_templates/1').to(action: :show, id: 1) }
    it { is_expected.to route(:get,     '/admin/email_templates/1/edit').to(action: :edit, id: 1) }
    it { is_expected.to route(:put,     '/admin/email_templates/1').to(action: :update, id: 1) }
  end

  describe 'index' do
    before { email_template; get :index }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:index) }
  end

  describe 'show' do
    before { get :show, id: email_template.to_param }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:show) }
  end

  describe 'update' do
    before { put :update, id: email_template.to_param, email_template: email_template.attributes.merge(body: 'A new body') }

    it { is_expected.to redirect_to("/admin/email_templates/#{email_template.to_param}") }
  end

  describe 'edit' do
    before { get :edit, id: email_template.to_param }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:edit) }
  end
end
