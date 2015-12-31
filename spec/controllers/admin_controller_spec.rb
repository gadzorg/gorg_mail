require 'rails_helper'

RSpec.describe AdminController, type: :controller do

include Devise::TestHelpers

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    sign_in FactoryGirl.create(:admin)
  end

  describe "GET #index" do
    it "returns http success" do

      setup

      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
