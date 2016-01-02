require 'rails_helper'

RSpec.describe UsersController, type: :controller do

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
      @admin_role=FactoryGirl.create(:role, name: 'admin')
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


  # describe "GET #create" do

  #   it_should_behave_like "an admin only endpoint", :new

  #   context "user login as admin" do
      
  #     before :each do
  #       @admin=FactoryGirl.create(:admin, firstname: 'Admin', email:'admin@hotmail.com')
  #       login @admin
  #     end

  #     context 'With valid data' do
  #       it { expect{post :create, user: FactoryGirl.attributes_for(:user)}.to change{User.count}.by(1) }
  #       it "respond with 302" do
  #         post :create, user: FactoryGirl.attributes_for(:user)
  #         is_expected.to respond_with :redirect
  #      end
  #      it "Redirect to create user #show" do
  #         post :create, user: FactoryGirl.attributes_for(:user)
  #         is_expected.to redirect_to user_path(assigns(:user).id)
  #      end
  #     end

  #     context 'With invalid data' do
  #       it {expect{post :create, user: FactoryGirl.attributes_for(:invalid_user)}.to_not change{User.count}}
  #       it "respond with 422" do
  #         post :create, user: FactoryGirl.attributes_for(:invalid_user)
  #         is_expected.to respond_with :unprocessable_entity
  #       end
  #       it "Redirect to create user #show" do
  #         post :create, user: FactoryGirl.attributes_for(:invalid_user)
  #         is_expected.to render_template :new
  #       end
  #     end
  #   end
  # end

  # describe "GET #destroy" do
  #   before :each do
  #       @user=FactoryGirl.create(:user)
  #   end

  #   it_should_behave_like "an admin only endpoint", :destroy, :id => 1

  #   context "user login as admin" do
      
  #     before :each do
  #       @admin=FactoryGirl.create(:admin, firstname: 'Admin', email:'admin@hotmail.com')
  #       login @admin
  #     end

  #     it "deletes the contact" do
  #       expect{delete :destroy, id: @user.id}.to change(User,:count).by(-1)
  #     end

  #     it "respond with 302" do
  #         delete :destroy, id: @user.id
  #         is_expected.to respond_with :redirect
  #      end
  #      it "Redirect to create user #show" do
  #         delete :destroy, id: @user.id
  #         is_expected.to redirect_to users_path
  #      end

  #   end
  # end
end
