require "spec_helper"

describe BreadTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/bread_types").should route_to("bread_types#index")
    end

    it "routes to #new" do
      get("/bread_types/new").should route_to("bread_types#new")
    end

    it "routes to #show" do
      get("/bread_types/1").should route_to("bread_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bread_types/1/edit").should route_to("bread_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bread_types").should route_to("bread_types#create")
    end

    it "routes to #update" do
      put("/bread_types/1").should route_to("bread_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bread_types/1").should route_to("bread_types#destroy", :id => "1")
    end

  end
end
