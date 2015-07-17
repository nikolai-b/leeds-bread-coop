describe SubscriptionsController, type: :controller do
  let(:subscriber)   { create :subscriber, :with_subscription }
  let(:subscription) { build :subscription, subscriber: nil }

  before do
    warden.set_user subscriber
    Stripe::Plan.create(id: 'weekly-bread-2', amount: 2000, name: 'weekly-sub_2', currency: 'GBP', interval: 4)
  end

  describe 'routing' do
    it { is_expected.to route(:get,     '/subscriptions/edit_all'    ).to(action: :edit_all  ) }
    it { is_expected.to route(:put,     '/subscriptions/update_all').to(action: :update_all) }
    it { is_expected.to route(:get,     '/subscriptions').to(action: :index) }
  end

  context 'with no stripe_customer_id' do
    describe 'index' do
      before { get :index }
      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:index) }
    end

    describe 'edit_all' do
      before { get :edit_all }
      it { is_expected.to respond_with(:success) }
      it { is_expected.to render_template(:edit_all) }
    end

    describe 'update_all' do
      before { put :update_all, { subscriptions: {subscriptions_attributes: {"1" => subscription.attributes }} } }
      it { is_expected.to redirect_to("/subscribers/#{subscriber.to_param}") }
    end
  end
end
