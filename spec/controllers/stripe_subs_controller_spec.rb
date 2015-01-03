describe StripeSubsController, type: :controller do
  let(:subscriber)    { create :subscriber, :with_subscription }
  let(:stripe_helper) { StripeMock.create_test_helper }

  before do
    warden.set_user subscriber
  end

  describe 'routing' do
    it { is_expected.to route(:get,     '/stripe_sub/new').to(action: :new) }
    it { is_expected.to route(:get,     '/stripe_sub/edit').to(action: :edit) }
    it { is_expected.to route(:post,    '/stripe_sub').to(action: :create) }
    it { is_expected.to route(:put,     '/stripe_sub').to(action: :update) }
    it { is_expected.to route(:delete,  '/stripe_sub').to(action: :destroy) }
  end

  describe 'new' do
    context 'with no stripe_customer_id' do
      before do
        subscriber.update stripe_account: nil
        get :new
      end
      it { is_expected.to render_template(:new) }
    end

    context 'with a stripe_customer_id' do
      before do
        get :new
      end

      it { is_expected.to render_template(:edit) }
    end
  end

  describe 'edit' do
    before { get :edit}
    it { is_expected.to respond_with(:success) }
  end

  describe 'update' do
    before { put :update, stripeToken: stripe_helper.generate_card_token }
    it { is_expected.to redirect_to("/subscribers/#{subscriber.id}")}
  end

  describe 'create' do
    before do
      notifier = double()

      expect(SubscriberNotifier).to receive(:new).once.and_return(notifier)
      expect(notifier).to receive(:new_sub).once

      post :create, stripeToken: stripe_helper.generate_card_token
    end
    it { is_expected.to redirect_to("/subscribers/#{subscriber.id}")}
  end

end
