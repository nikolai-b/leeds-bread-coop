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
end
