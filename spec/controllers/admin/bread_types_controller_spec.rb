describe Admin::BreadTypesController, type: :controller do
  before do
    warden.set_user admin
  end
  let(:admin) { create :subscriber, :admin }
  let(:bread_type) { create :bread_type }

  describe 'routing' do
    it { is_expected.to route(:get,     '/admin/bread_types').to(action: :index) }
    it { is_expected.to route(:post,    '/admin/bread_types').to(action: :create) }
    it { is_expected.to route(:get,     '/admin/bread_types/new').to(action: :new) }
    it { is_expected.to route(:get,     '/admin/bread_types/1').to(action: :show, id: 1) }
    it { is_expected.to route(:get,     '/admin/bread_types/1/edit').to(action: :edit, id: 1) }
    it { is_expected.to route(:put,     '/admin/bread_types/1').to(action: :update, id: 1) }
  end

  describe 'index' do
    before { bread_type; get :index }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:index) }
  end

  describe 'show' do
    before { get :show, id: bread_type.to_param }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:show) }
  end

  describe 'create' do
    before { post :create, bread_type: bread_type.attributes.merge(name: 'New bread') }

    it { is_expected.to respond_with(:redirect) }
    it { is_expected.to set_the_flash.to(/successfully created/) }
  end

  describe 'update' do
    before { put :update, id: bread_type.to_param, bread_type: bread_type.attributes.merge(name: 'New bread') }

    it { is_expected.to redirect_to("/admin/bread_types/#{bread_type.to_param}") }
  end

  describe 'new' do
    before { get :new }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:new) }
  end

  describe 'edit' do
    before { get :edit, id: bread_type.to_param }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:edit) }
  end
end
