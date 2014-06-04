require "spec_helper"

describe WholesaleCustomersController do
  describe "routing" do

    it "routes to #index" do
      get("/wholesale_customers").should route_to("wholesale_customers#index")
    end

    it "routes to #new" do
      get("/wholesale_customers/new").should route_to("wholesale_customers#new")
    end

    it "routes to #show" do
      get("/wholesale_customers/1").should route_to("wholesale_customers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/wholesale_customers/1/edit").should route_to("wholesale_customers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/wholesale_customers").should route_to("wholesale_customers#create")
    end

    it "routes to #update" do
      put("/wholesale_customers/1").should route_to("wholesale_customers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/wholesale_customers/1").should route_to("wholesale_customers#destroy", :id => "1")
    end

  end
end
