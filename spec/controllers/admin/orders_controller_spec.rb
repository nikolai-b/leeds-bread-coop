describe Admin::OrdersController, type: :controller do
  before do
    warden.set_user admin
  end
  let(:admin) { create :subscriber, :admin }
  let(:order) { create :order }

  describe 'routing' do
    it { is_expected.to route(:get,     '/admin/orders').to(action: :index) }
    it { is_expected.to route(:post,    '/admin/orders').to(action: :create) }
    it { is_expected.to route(:get,     '/admin/orders/new').to(action: :new) }
    it { is_expected.to route(:get,     '/admin/orders/1').to(action: :show, id: 1) }
    it { is_expected.to route(:get,     '/admin/orders/1/edit').to(action: :edit, id: 1) }
    it { is_expected.to route(:put,     '/admin/orders/1').to(action: :update, id: 1) }
    it { is_expected.to route(:delete,  '/admin/orders/1').to(action: :destroy, id: 1) }
  end

  describe 'index' do
    before { get :index }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:index) }
  end

  describe 'show' do
    before { get :show, id: order.to_param }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:show) }
  end

  describe 'create' do
    before { post :create, order: order.attributes.merge(name: 'New point') }

    it { is_expected.to respond_with(:redirect) }
    it { is_expected.to set_the_flash.to(/successfully created/) }
  end

  describe 'update' do
    before { put :update, id: order.to_param, order: order.attributes.merge(name: 'New point') }

    it { is_expected.to redirect_to("/admin/orders/#{order.to_param}") }
  end

  describe 'new' do
    before { get :new }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:new) }
  end

  describe 'edit' do
    before { get :edit, id: order.to_param }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:edit) }
  end
end
