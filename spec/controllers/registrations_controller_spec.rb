describe RegistrationsController do
  def setup
    @request.env["devise.mapping"] = Devise.mappings[:subscriber]
    sign_in subscriber
  end

  let(:subscriber) { create :subscriber }
  let(:valid_attributes) { {id: subscriber.to_param } }

  before do
    setup
  end

  it 'cancels subs on destroy' do
    expect_any_instance_of(StripeSub).to receive(:cancel).once

    delete :destroy
  end
end
