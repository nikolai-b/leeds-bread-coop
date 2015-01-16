describe HolidaysController, type: :controller do
  before do
    warden.set_user subscriber
  end
  let(:subscriber) { create :subscriber }
  let(:holiday)    { build :holiday, subscriber_id: subscriber.id }

  describe 'routing' do
    it { is_expected.to route(:get,  '/subscribers/1/holidays').to(action: :index, subscriber_id: 1) }
    it { is_expected.to route(:post, '/subscribers/1/holidays').to(action: :create, subscriber_id: 1) }
    it { is_expected.to route(:get,  '/subscribers/1/holidays/new').to(action: :new, subscriber_id: 1) }
    it { is_expected.to route(:get,  '/subscribers/1/holidays/1').to(action: :show, subscriber_id: 1, id: 1) }
  end

  context 'with a holiday' do
    before { holiday.save }

    describe 'index' do
      before { get :index, subscriber_id: subscriber.to_param }
      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:index) }
    end

    describe 'show' do
      before { get :show, subscriber_id: subscriber.to_param, id: holiday.to_param }
      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:show) }
    end
  end

  describe 'new' do
    before { get :new, subscriber_id: subscriber.to_param }
    it { is_expected.to respond_with(:success) }
  end

  describe 'create' do
    before { post :create, subscriber_id: subscriber.to_param, holiday: holiday.attributes }
    it { is_expected.to redirect_to("/subscribers/#{subscriber.id}/holidays/#{Holiday.last.id}") }
  end
end


