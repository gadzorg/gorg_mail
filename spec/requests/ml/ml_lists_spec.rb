require 'rails_helper'

RSpec.describe "Ml::Lists", type: :request do
  describe "GET /ml_lists" do
    it "works! (now write some real specs)" do
      get ml_lists_path
      expect(response).to have_http_status(200)
    end
  end
end
