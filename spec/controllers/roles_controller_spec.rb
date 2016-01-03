require 'rails_helper'

RSpec.describe RolesController, type: :controller do

include Devise::TestHelpers

  def login(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  shared_examples_for "an admin only endpoint" do |destination, params|
    context "user login as basic user" do
      before :each do
        @user||=FactoryGirl.create(:user, firstname: 'Ulysse', email:'Ulysse@hotmail.com')
        login @user
        get destination, params
      end

      it { is_expected.to respond_with :forbidden }
    end

    context "user not login" do
      before :each do
        @user=FactoryGirl.create(:user, firstname: 'Ulysse', email:'Ulysse@hotmail.com')
        get destination, params
      end

      it { is_expected.to respond_with :redirect}
      it { is_expected.to redirect_to new_user_session_path}
    end
  end

  describe "GET #index" do

    before :each do
      @admin_role=FactoryGirl.create(:role, name:"admin")
      @support_role=FactoryGirl.create(:role, name: 'support')
    end

    it_should_behave_like "an admin only endpoint", :index

    context "user login as admin" do
      
      before :each do
        @admin=FactoryGirl.create(:admin, firstname: 'Admin', email:'admin@hotmail.com')
        login @admin
        get :index
      end

      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :index }
      it "populate @roles list with all roles" do
        expect(assigns(:roles)).to eq([@admin_role, @support_role])
      end
    end    
  end

end
