require 'rails_helper'

RSpec.describe ExternalInvitationController, type: :controller do

  describe "GET #accept_cgu" do
    it "returns http success" do
      get :accept_cgu
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #accept_invitation" do
    it "returns http success" do
      get :accept_invitation
      expect(response).to have_http_status(:success)
    end
  end

end
