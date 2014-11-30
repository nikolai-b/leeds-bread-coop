describe Admin::SubscribersController, type: :controller do
  before do
    warden.set_user admin
  end
  let(:admin)        { create :subscriber, :admin }
  let(:subscriber)   { create :subscriber, :with_subscription }
  let(:subscription) { subscriber.subscriptions.first }

  describe 'routing' do
    it { is_expected.to route(:get, "/admin/subscriptions/#{subscriber.id}/subscriptions/").to(action: :index, subscriber_id: subscriber.id) }
    it { is_expected.to route(:get, "/admin/subscriptions/#{subscriber.id}/subscriptions/edit_all").to(action: :edit_all, subscriber_id: subscriber.id) }
    it { is_expected.to route(:put, "/admin/subscriptions/#{subscriber.id}/subscriptions/update_all").to(action: :update_all, subscriber_id: subscriber.id) }
  end

  describe 'index' do
    before { get :index, subscriber_id: subscriber.id }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:index) }
  end

  describe 'edit_all' do
    before { get :edit_all, id: subscription.to_param }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:edit_all) }
  end

  describe 'update_all' do
    before { put :update_all, { subscriptions: {subscriptions_attributes: {"1" => subscription.attributes }} } }

    it { is_expected.to set_the_flash.to(/successfully created/) }
    it { is_expected.to redirect_to("admin/subscribers/#{subscriber.to_param}") }
  end
end
