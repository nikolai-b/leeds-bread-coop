describe Admin::CollectionPointsController, type: :controller do
  before do
    warden.set_user admin
  end
  let(:admin) { create :subscriber, :admin }
  let(:collection_point) { create :collection_point }

  describe 'routing' do
    it { is_expected.to route(:get,     '/admin/collection_points').to(action: :index) }
    it { is_expected.to route(:post,    '/admin/collection_points').to(action: :create) }
    it { is_expected.to route(:get,     '/admin/collection_points/new').to(action: :new) }
    it { is_expected.to route(:get,     '/admin/collection_points/1').to(action: :show, id: 1) }
    it { is_expected.to route(:get,     '/admin/collection_points/1/edit').to(action: :edit, id: 1) }
    it { is_expected.to route(:put,     '/admin/collection_points/1').to(action: :update, id: 1) }
    it { is_expected.to route(:delete,  '/admin/collection_points/1').to(action: :destroy, id: 1) }
  end

  describe 'index' do
    before { get :index }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:index) }
  end

  describe 'show' do
    before { get :show, id: collection_point.to_param }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:show) }
  end

  describe 'create' do
    before { post :create, collection_point: collection_point.attributes.merge(name: 'New point') }

    it { is_expected.to respond_with(:redirect) }
    it { is_expected.to set_the_flash.to(/successfully created/) }
  end

  describe 'update' do
    before { put :update, id: collection_point.to_param, collection_point: collection_point.attributes.merge(name: 'New point') }

    it { is_expected.to redirect_to("/admin/collection_points/#{collection_point.to_param}") }
  end

  describe 'new' do
    before { get :new }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:new) }
  end

  describe 'edit' do
    before { get :edit, id: collection_point.to_param }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:edit) }
  end
end
