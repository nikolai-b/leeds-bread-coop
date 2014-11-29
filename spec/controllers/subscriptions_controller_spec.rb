describe SubscriptionsController, type: :controller do
  before do
    StripeMock.start
    Stripe::Plan.create(id: 'weekly-bread-1', amount: 1000, name: 'weekly-sub', currency: 'GBP', interval: 4)
    warden.set_user subscriber
  end

  let(:stripe_helper) { StripeMock.create_test_helper }
  let(:subscriber)    { create :subscriber, :with_subscription, :with_payment_card }
  let(:subscription)  { build :subscription, subscriber: subscriber}

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
