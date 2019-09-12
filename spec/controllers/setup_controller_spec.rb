require 'rails_helper'

RSpec.describe SetupController, type: :controller do
  let(:valid_ml_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns setup ml_lists as @mailing_lists" do
      list = Ml::List.create! valid_ml_attributes
      get :index, session: valid_session
      expect(assigns(:mailing_lists)).to eq([])
    end
  end

end
