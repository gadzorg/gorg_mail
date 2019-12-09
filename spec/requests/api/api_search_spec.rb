require 'rails_helper'

RSpec.describe "Api::Search", type: :request do
  let(:user){ create(:user_with_addresses)}

  let(:source_address){user.email_source_accounts.first}

  describe "GET /api/search/test" do

    before(:each) do
      get api_search_path(query), headers: headers
    end

    context "authentificated" do

      let(:headers) {{
          'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(
              Rails.application.secrets.api_user,Rails.application.secrets.api_password)
      }}

      context "existing account" do
        let(:query){source_address.to_s}

        it "have status 200" do
          expect(response).to have_http_status(200)
        end

        it "returns user UUID" do
          expect(JSON.parse(response.body)).to include("uuid" => user.uuid)
        end
      end

      context "not existing account" do
        let(:query){"not_existent@example.com"}

        it "have status 404" do
          expect(response).to have_http_status(404)
        end

        it "returns an error" do
          expect(JSON.parse(response.body)).to include("error" => {"status" => 404, "message" => "Email not found"})
        end

      end
    end
  end
end
