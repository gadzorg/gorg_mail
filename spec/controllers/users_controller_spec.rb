require 'rails_helper'

RSpec.describe UsersController, type: :controller do

include Devise::TestHelpers

  def login(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  shared_examples_for "an admin only endpoint" do |destination|
    let! (:params) {}
    context "user login as basic user" do

      before :each do
        @c_user||=FactoryGirl.create(:user, firstname: 'Ulysse', email:'Ulysse@hotmail.com')
        login @c_user
        get destination, params
      end

      it { is_expected.to respond_with :forbidden }
    end

    context "user not login" do
      before :each do
        get destination, params
      end

      it { is_expected.to respond_with :redirect}
      it { is_expected.to redirect_to new_user_session_path}
    end
  end

  describe "GET #index" do

    before :each do
      @alice = FactoryGirl.create(:user, firstname: 'Alice', email:'alice@hotmail.com')
      @bob = FactoryGirl.create(:user, firstname: 'Bob', email:'bob@hotmail.com')
      @charlie = FactoryGirl.create(:user, firstname: 'Charlie', email:'charlie@hotmail.com')
    end

    #it_should_behave_like "an admin only endpoint", :index

    context "user login as admin" do
      
      before :each do
        @admin=FactoryGirl.create(:admin, firstname: 'Admin', email:'admin@hotmail.com')
        login @admin
        get :index
      end

      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :index }
      it "populate @users list with all users" do
        expect(assigns(:users)).to eq([@alice, @bob, @charlie, @admin])
      end
    end    
  end

  describe "GET #show" do
    before :each do
        @user=FactoryGirl.create(:user)
    end

    #it_should_behave_like "an admin only endpoint", :show  do 
    #   let! (:params) {{:id => @user.id}}
    # end

    context "user login as admin" do

      context "using user id" do
        let(:id) {@user.id}

        before :each do
          @admin=FactoryGirl.create(:admin, firstname: 'Admin', email:'admin@hotmail.com')
          login @admin
          get :show, :id => @user.hruid
        end

        it { is_expected.to respond_with :success }
        it { is_expected.to render_with_layout :application }
        it { is_expected.to render_template :show }
        it "populate @user list with requested user" do
          expect(assigns(:user)).to eq(@user)
        end
      end

      context "using user uuid" do
        let(:id) {@user.uuid}

        before :each do
          @admin=FactoryGirl.create(:admin, firstname: 'Admin', email:'admin@hotmail.com')
          login @admin
          get :show, :id => @user.hruid
        end

        it { is_expected.to respond_with :success }
        it { is_expected.to render_with_layout :application }
        it { is_expected.to render_template :show }
        it "populate @user list with requested user" do
          expect(assigns(:user)).to eq(@user)
        end
      end

      context "using user hruid" do
        let(:id) {@user.hruid}

        before :each do
          @admin=FactoryGirl.create(:admin, firstname: 'Admin', email:'admin@hotmail.com')
          login @admin
          get :show, :id => @user.hruid
        end

        it { is_expected.to respond_with :success }
        it { is_expected.to render_with_layout :application }
        it { is_expected.to render_template :show }
        it "populate @user list with requested user" do
          expect(assigns(:user)).to eq(@user)
        end
      end
    end    
  end

  describe "GET #new" do

    it_should_behave_like "an admin only endpoint", :new

    context "user login as admin" do
      
      before :each do
        @admin=FactoryGirl.create(:admin, firstname: 'Admin', email:'admin@hotmail.com')
        login @admin
        get :new
      end

      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :new}
      it "populate @user list new user" do
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end

  describe "GET #create" do

    it_should_behave_like "an admin only endpoint", :new

    context "user login as admin" do
      
      before :each do
        @admin=FactoryGirl.create(:admin, firstname: 'Admin', email:'admin@hotmail.com')
        login @admin
      end

      context 'With valid data' do
        it { expect{post :create, user: FactoryGirl.attributes_for(:user)}.to change{User.count}.by(1) }
        it "respond with 302" do
          post :create, user: FactoryGirl.attributes_for(:user)
          is_expected.to respond_with :redirect
       end
       it "Redirect to create user #show" do
          post :create, user: FactoryGirl.attributes_for(:user)
          is_expected.to redirect_to user_path(assigns(:user).id)
       end
      end

      context 'With invalid data' do
        it {expect{post :create, user: FactoryGirl.attributes_for(:invalid_user)}.to_not change{User.count}}
        it "respond with 422" do
          post :create, user: FactoryGirl.attributes_for(:invalid_user)
          is_expected.to respond_with :unprocessable_entity
        end
        it "Redirect to create user #show" do
          post :create, user: FactoryGirl.attributes_for(:invalid_user)
          is_expected.to render_template :new
        end
      end
    end
  end

  describe "GET #edit" do
    before :each do
        @user=FactoryGirl.create(:user)
    end

    it_should_behave_like "an admin only endpoint", :edit do 
      let! (:params) {{:id => @user.id}}
    end

    context "user login as admin" do
      
      before :each do
        @admin=FactoryGirl.create(:admin, firstname: 'Admin', email:'admin@hotmail.com')
        login @admin
        get :edit, :id => @user.id
      end

      it { is_expected.to respond_with :success }
      it { is_expected.to render_with_layout :application }
      it { is_expected.to render_template :edit }
      it "populate @user list expected user" do
        expect(assigns(:user)).to eq(@user)
      end
    end
  end

  describe "GET #update" do
    before :each do
        @user=FactoryGirl.create(:user, firstname:'Bob',email:'bob@hotmail.com')
    end

    it_should_behave_like "an admin only endpoint", :update do 
      let! (:params) {{:id => @user.id}}
    end

    context "user login as admin" do
      
      before :each do
        @admin=FactoryGirl.create(:admin, firstname: 'Admin', hruid: 'admin.test.ext',email:'admin@hotmail.com')
        login @admin
      end

      context 'With valid data' do
        before :each do
          post :update, :id => @user.id, user: FactoryGirl.attributes_for(:user, firstname:'Bobby')
        end
        it "update user data" do
          expect(User.find(@user.id).firstname).to eq('Bobby')
        end
        it "populate @user list expected user" do
          expect(assigns(:user)).to eq(@user)
        end
        it {is_expected.to respond_with :redirect}
        it {is_expected.to redirect_to user_path(@user.id)}
      end

      context 'With invalid data' do
        before :each do
          post :update, :id => @user.id, user: FactoryGirl.attributes_for(:user, firstname:'Bobby', hruid:'')
        end

        it "doesn't update user data" do
          expect(User.find(@user.id).hruid).to_not eq('')
          #expect(User.find(@user.id).hruid).to eq('admin.test.ext')
        end        
        it "respond with 422" do
          post :create, user: FactoryGirl.attributes_for(:invalid_user)
          is_expected.to respond_with :unprocessable_entity
       end
       it "Redirect to create user #show" do
          post :create, user: FactoryGirl.attributes_for(:invalid_user)
          is_expected.to render_template :new
       end
      end
    end
  end

  describe "GET #destroy" do
    before :each do
        @user=FactoryGirl.create(:user)
    end

    it_should_behave_like "an admin only endpoint", :destroy do 
      let! (:params) {{:id => @user.id}}
    end

    context "user login as admin" do
      
      before :each do
        @admin=FactoryGirl.create(:admin, firstname: 'Admin', email:'admin@hotmail.com')
        login @admin
      end

      it "deletes the contact" do
        expect{delete :destroy, id: @user.id}.to change(User,:count).by(-1)
      end

      it "respond with 302" do
          delete :destroy, id: @user.id
          is_expected.to respond_with :redirect
       end
       it "Redirect to create user #show" do
          delete :destroy, id: @user.id
          is_expected.to redirect_to users_path
       end

    end
  end
end
