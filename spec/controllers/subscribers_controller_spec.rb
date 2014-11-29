describe SubscribersController, type: :controller do
  before do
    warden.set_user subscriber
  end

  let(:subscriber) { create :subscriber }

  describe 'routing' do
    it { is_expected.to route(:get,  '/subscribers/1').to(action: :show, id: 1) }
  end

  describe 'show' do
    before { get :show, id: subscriber.to_param }
    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:show) }
  end
end

