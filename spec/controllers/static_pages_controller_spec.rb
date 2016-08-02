require 'rails_helper'
include Devise::TestHelpers

RSpec.describe StaticPagesController, type: :controller do
  describe "GET #index" do
    before :each do
        get :landing
    end
    it { is_expected.to respond_with :success }
  end
end