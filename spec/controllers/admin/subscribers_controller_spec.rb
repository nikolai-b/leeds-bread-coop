describe Admin::SubscribersController, type: :controller do
  before do
    warden.set_user admin
  end
  let(:admin) { create :subscriber, :admin }
  let(:subscriber) { create :subscriber }
  let(:file) { Rack::Test::UploadedFile.new('spec/fixtures/subscriber_import.csv','text/csv') }

  describe 'routing' do
    it { is_expected.to route(:get,     '/admin/subscribers').to(action: :index) }
    it { is_expected.to route(:post,    '/admin/subscribers').to(action: :create) }
    it { is_expected.to route(:get,     '/admin/subscribers/new').to(action: :new) }
    it { is_expected.to route(:get,     '/admin/subscribers/1').to(action: :show, id: 1) }
    it { is_expected.to route(:get,     '/admin/subscribers/1/edit').to(action: :edit, id: 1) }
    it { is_expected.to route(:put,     '/admin/subscribers/1').to(action: :update, id: 1) }
    it { is_expected.to route(:delete,  '/admin/subscribers/1').to(action: :destroy, id: 1) }
    it { is_expected.to route(:post,    '/admin/subscribers/import').to(action: :import) }
  end

  describe 'index' do
    before { get :index }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:index) }
  end

  describe 'show' do
    before { get :show, id: subscriber.to_param }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:show) }
  end

  describe 'create' do
    before { post :create, subscriber: subscriber.attributes.merge(name: 'New subscriber') }

    it { is_expected.to respond_with(:redirect) }
    it { is_expected.to set_the_flash.to(/successfully created/) }
  end

  describe 'update' do
    before { put :update, id: subscriber.to_param, subscriber: subscriber.attributes.merge(name: 'New subscriber') }

    it { is_expected.to redirect_to("/admin/subscribers/#{subscriber.to_param}") }
  end

  describe 'new' do
    before { get :new }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:new) }
  end

  describe 'edit' do
    before { get :edit, id: subscriber.to_param }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:edit) }
  end

  describe 'import' do
    before do
      load 'db/seeds.rb'
      post :import, file: file
    end

    it { is_expected.to respond_with(:success) }
  end
end
