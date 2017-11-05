require 'rails_helper'

RSpec.describe "Bishops", type: :request do
  describe "GET /bishops" do
    it "works! (now write some real specs)" do
      get bishops_path
      expect(response).to have_http_status(200)
    end
  end
end
