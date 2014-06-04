require 'spec_helper'

describe "WholesaleCustomers" do
  describe "GET /wholesale_customers" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get wholesale_customers_path
      response.status.should be(200)
    end
  end
end
