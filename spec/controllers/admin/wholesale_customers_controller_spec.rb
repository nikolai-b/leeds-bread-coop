describe Admin::WholesaleCustomersController, type: :controller do
  before do
    warden.set_user admin
  end
  let(:admin) { create :subscriber, :admin }
  let(:wholesale_customer) { create :wholesale_customer }

  describe 'routing' do
    it { is_expected.to route(:get,     '/admin/wholesale_customers').to(action: :index) }
    it { is_expected.to route(:post,    '/admin/wholesale_customers').to(action: :create) }
    it { is_expected.to route(:get,     '/admin/wholesale_customers/new').to(action: :new) }
    it { is_expected.to route(:get,     '/admin/wholesale_customers/1').to(action: :show, id: 1) }
    it { is_expected.to route(:get,     '/admin/wholesale_customers/1/edit').to(action: :edit, id: 1) }
    it { is_expected.to route(:put,     '/admin/wholesale_customers/1').to(action: :update, id: 1) }
  end
  describe 'index' do
    before { wholesale_customer; get :index }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:index) }
  end

  describe 'show' do
    before { get :show, id: wholesale_customer.to_param }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:show) }
  end

  describe 'create' do
    before { post :create, wholesale_customer: wholesale_customer.attributes.merge(name: 'New Customer') }

    it { is_expected.to respond_with(:redirect) }
    it { is_expected.to set_the_flash.to(/successfully created/) }
  end

  describe 'update' do
    before { put :update, id: wholesale_customer.to_param, wholesale_customer: wholesale_customer.attributes.merge(name: 'New Customer') }

    it { is_expected.to redirect_to("/admin/wholesale_customers/#{wholesale_customer.to_param}") }
  end

  describe 'new' do
    before { get :new }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:new) }
  end

  describe 'edit' do
    before { get :edit, id: wholesale_customer.to_param }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:edit) }
  end
end
