describe Admin::SubscriptionsController, type: :controller do

  before do
    warden.set_user admin
  end
  let(:subscriber)    { create :subscriber, :with_subscription }
  let(:subscription) { subscriber.subscriptions.first }
  let(:admin)        { create :subscriber, :admin }

  describe 'routing' do
    it { is_expected.to route(:get, "/admin/subscribers/#{subscriber.id}/subscriptions/edit_all").to(action: :edit_all, subscriber_id: subscriber.id) }
    it { is_expected.to route(:put, "/admin/subscribers/#{subscriber.id}/subscriptions/update_all").to(action: :update_all, subscriber_id: subscriber.id) }
  end

  describe 'edit_all' do
    before { get :edit_all, subscriber_id: subscriber.to_param }

    it { is_expected.to respond_with(:success) }
    it { is_expected.to render_template(:edit_all) }
  end

  describe 'update_all' do
    context 'with subscriptions' do
      before { put :update_all, subscriptions: {subscription_attributes: {"1437125740314" => subscription.attributes }}, subscriber_id: subscriber.to_param  }

      it { is_expected.to set_the_flash.to(/successfully updated/) }
      it { is_expected.to redirect_to("/admin/subscribers/#{subscriber.to_param}") }
    end
    context 'without subscriptions' do
      before { put :update_all, subscriber_id: subscriber.to_param  }

      it { is_expected.to respond_with(:ok) }
    end
  end
end
