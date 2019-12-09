require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  def login(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  shared_examples_for "an admin only endpoint" do |destination, params|
    context "user login as basic user" do
      before :each do
        @user||= create(:user, firstname: 'Ulysse', email:'Ulysse@hotmail.com')
        login @user
        get destination
      end

      it { is_expected.to respond_with :forbidden }
    end

    context "user not login" do
      before :each do
        @user= create(:user, firstname: 'Ulysse', email:'Ulysse@hotmail.com')
        get destination
      end

      it { is_expected.to respond_with :redirect}
      it { is_expected.to redirect_to new_user_session_path}
    end
  end


  describe "GET #index" do
    it_should_behave_like "an admin only endpoint", :index

    context "user login as admin" do

      before :each do
        @admin= create(:admin, firstname: 'Admin', email:'admin@hotmail.com')
        login @admin
        get :index
      end

      it { is_expected.to respond_with :success }
    end

  end



end
