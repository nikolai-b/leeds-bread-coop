describe RegistrationsController do
  let(:subscriber) { create :subscriber }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:subscriber]
    sign_in subscriber
  end

  describe 'update' do
    context 'with no need for password' do
      before { put :update, subscriber: subscriber.attributes.merge("phone" => "01131234567")}

      it { is_expected.to set_the_flash.to(/account successfully/) }
      it { is_expected.to redirect_to("/subscribers/#{subscriber.to_param}") }
    end
  end
end
