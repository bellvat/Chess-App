require "rails_helper"

RSpec.describe BishopsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/bishops").to route_to("bishops#index")
    end

    it "routes to #new" do
      expect(:get => "/bishops/new").to route_to("bishops#new")
    end

    it "routes to #show" do
      expect(:get => "/bishops/1").to route_to("bishops#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/bishops/1/edit").to route_to("bishops#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/bishops").to route_to("bishops#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/bishops/1").to route_to("bishops#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/bishops/1").to route_to("bishops#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/bishops/1").to route_to("bishops#destroy", :id => "1")
    end

  end
end
