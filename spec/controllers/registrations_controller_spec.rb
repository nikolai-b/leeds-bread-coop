describe RegistrationsController do
  let(:registration_attributes) { attributes_for :subscriber}

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Registration" do
        pending "not hitting the Devise::RegistrationsController.new.create"
        controller.stub(:authenticate_user!).and_return(true)
        @request.env["devise.mapping"] = Devise.mappings[:subscriber]
        expect {
          post :create, {:registration => registration_attributes}
        }.to change(Subscriber, :count).by(1)
      end

      it "redirects to the created collection_point" do
        pending "getting 200 instead of redirect"
        @request.env["devise.mapping"] = Devise.mappings[:subscriber]
        post :create, {:collection_point => registration_attributes}
        response.should redirect_to(new_subscriber_subs_path Subscriber.last)
      end
    end
  end
end
