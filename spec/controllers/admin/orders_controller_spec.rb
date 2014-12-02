describe Admin::OrdersController, type: :controller do
  before do
    warden.set_user admin
  end
  let(:admin) { create :subscriber, :admin }
  let(:order) { create :order }
  let(:wholesale) { order.wholesale_customer }

  describe 'routing' do
    it { is_expected.to route(:get,     "/admin/wholesale_customers/#{wholesale.id}/orders"       ).to(action: :index,   wholesale_customer_id: wholesale.id) }
    it { is_expected.to route(:post,    "/admin/wholesale_customers/#{wholesale.id}/orders"       ).to(action: :create,  wholesale_customer_id: wholesale.id) }
    it { is_expected.to route(:get,     "/admin/wholesale_customers/#{wholesale.id}/orders/new"   ).to(action: :new,     wholesale_customer_id: wholesale.id) }
    it { is_expected.to route(:get,     "/admin/wholesale_customers/#{wholesale.id}/orders/1"     ).to(action: :show,    wholesale_customer_id: wholesale.id, id: 1) }
    it { is_expected.to route(:get,     "/admin/wholesale_customers/#{wholesale.id}/orders/1/edit").to(action: :edit,    wholesale_customer_id: wholesale.id, id: 1) }
    it { is_expected.to route(:put,     "/admin/wholesale_customers/#{wholesale.id}/orders/1"     ).to(action: :update,  wholesale_customer_id: wholesale.id, id: 1) }
    it { is_expected.to route(:delete,  "/admin/wholesale_customers/#{wholesale.id}/orders/1"     ).to(action: :destroy, wholesale_customer_id: wholesale.id, id: 1) }
  end

  describe 'index' do
    before { order; get :index, wholesale_customer_id: wholesale.id}

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:index) }
  end

  describe 'show' do
    before { get :show, id: order.to_param, wholesale_customer_id: wholesale.id }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:show) }
  end

  describe 'create' do
    before { post :create, order: order.attributes.merge(name: 'New point'), wholesale_customer_id: wholesale.id }

    it { is_expected.to respond_with(:redirect) }
    it { is_expected.to set_the_flash.to(/successfully created/) }
  end

  describe 'update' do
    before { put :update, id: order.to_param, order: order.attributes.merge(name: 'New point'), wholesale_customer_id: wholesale.id}

    it { is_expected.to redirect_to("/admin/wholesale_customers/#{wholesale.id}/orders/#{order.to_param}") }
  end

  describe 'new' do
    before { get :new, wholesale_customer_id: wholesale.id }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:new) }
  end

  describe 'edit' do
    before { get :edit, id: order.to_param, wholesale_customer_id: wholesale.id }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:edit) }
  end
end
