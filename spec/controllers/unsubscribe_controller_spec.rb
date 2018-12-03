require 'rails_helper'

RSpec.describe UnsubscribeController, type: :controller do

  describe "GET #email_form" do
    it "returns http success" do
      get :email_form
      expect(response).to have_http_status(:success)
    end
  end
end
