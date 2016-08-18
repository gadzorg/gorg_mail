# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  hruid                  :string
#  firstname              :string
#  lastname               :string
#  role_id                :integer
#  last_gram_sync_at      :datetime
#

require 'rails_helper'

RSpec.describe User, type: :model do
  def gram_account_mocked (hash={})
    @gen_gram_account={
      "hruid"=>"alexandre.narbonne.2011",
      "firstname"=>"Alexandre",
      "lastname"=>"NARBONNE",
      "id_soce"=>"84189",
      "enable"=>"TRUE",
      "id"=>85189,
      "uid_number"=>85189,
      "gid_number"=>85189,
      "home_directory"=>"/nonexistant",
      "alias"=>["alexandre.narbonne.2011", "84189", "84189J"],
      "password"=>"Not Display",
      "email"=>"alexandre.narbonne",
      "email_forge"=>"alexandre.narbonne@gadz.org",
      "birthdate"=>"1987-09-17 00:00:00",
      "login_validation_check"=>"CGU=2015-06-04;",
      "description"=>"Agoram inscription - via module register - creation 2015-06-04 11:32:48",
      "entities"=>["comptes", "gram"]
    }

    @gen_gram_account.merge(hash).to_json
  end

  def omniauth_hash(hash={})
    @gen_omniauth_hash={"provider"=>"GadzOrg",
      "uid"=>"alexandre.narbonne.2011",
      "info"=>{"email"=>"alexandre.narbonne@gadz.org",
        "name"=>"alexandre.narbonne@gadz.org"},
        "credentials"=>{"ticket"=>"ST-120-SOPFsbPYKwW1qx3ax0NK-cas"},
        "extra"=>{
          "user"=>"alexandre.narbonne.2011",
          "username"=>"alexandre.narbonne.2011",
          "lastname"=>"NARBONNE",
          "firstname"=>"Alexandre",
          "soce_id"=>"84189"
        }
      }

    @gen_omniauth_hash.merge(hash)
  end
  
  it "has a valid factory" do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  it "is invalid if hruid already exist" do
    FactoryGirl.create(:user,hruid:"alexandre.narbonne.2011")
    expect(FactoryGirl.build(:user,hruid:"alexandre.narbonne.2011")).not_to be_valid
  end

  it "is invalid if email have invalid format" do
    expect(FactoryGirl.build(:user,email:"invalid_email")).not_to be_valid
  end


  describe "can have a role" do
    context 'has a role' do

      before :each do
        @user = FactoryGirl.create(:admin)
      end

      it "confirms its role" do
        expect(@user.has_role? :admin).to eq(true)
      end

      it "infirm false role" do
        expect(@user.has_role? :support).to eq(false)
      end

      it "change role" do
        @user.add_role :support
        expect(@user.role.name).to eq("support")
      end

      it "remove any role" do
        @user.remove_role
        expect(@user.role).to eq(nil)
      end

      describe "remove a specific role" do
        it "remove current role" do
          @user.remove_role :admin
          expect(@user.role).to eq(nil)
        end

        it "doesn't remove other roles" do
          @user.remove_role :support
          expect(@user.role.name).to eq("admin")
        end
      end
    end

    context "hasn't a role" do

      before :each do
        @user = FactoryGirl.create(:user, role_id: nil)
      end

      it "respond false" do
        expect(@user.has_role? :support).to eq(false)
      end
    end
  end


  it "has the attribute synced_with_gram" do
    expect(FactoryGirl.create(:user,hruid:"alexandre.narbonne.2011")).respond_to? :synced_with_gram
  end

  describe "has default value when initialized" do
    it "is not sync with gram at init" do
      expect(FactoryGirl.create(:user).synced_with_gram).to eq(false)
    end
  end

  describe "upgrade from gram data via API" do
    context "has an hruid" do

      before :each do
        @user = FactoryGirl.create(:user,firstname:'Alex', lastname:'Narbon',email:'un.email@email.com',hruid:"alexandre.narbonne.2011")
      end

      context "can connect to gram" do

        before :each do

          @gram_get_account_response=gram_account_mocked({'firstname' => 'Alexandre', 'lastname' => 'NARBONNE' ,'email' => 'alexandre.narbonne@gadz.org'})

          ActiveResource::HttpMock.respond_to do |mock|
            mock.get '/api/v1/accounts/alexandre.narbonne.2011/accounts.json', {'Accept' => 'application/json', "Authorization"=>"Basic cmF0YXRvc2s6dGVzdF9wYXNz"}, @gram_get_account_response, 200
          end
          @user=@user.update_from_gram
        end 

        it "return a User" do
          expect(@user.class).to eq(User)
        end

        it "update email with value from GrAM" do
          expect(User.find(@user.id).email).to eq("alexandre.narbonne@gadz.org")
        end

        it "update firstname with value from GrAM" do
          expect(User.find(@user.id).firstname).to eq("Alexandre")
        end

        it "update lastname with value from GrAM" do
          expect(User.find(@user.id).lastname).to eq("NARBONNE")
        end

        it "is synced with gram" do
          expect(@user.synced_with_gram).to eq (true)
        end
      end

      context "cannot connect to gram" do

        before :each do
          ActiveResource::HttpMock.respond_to do |mock|
            mock.get '/api/v1/accounts/alexandre.narbonne.2011/accounts.json', {'Accept' => 'application/json', "Authorization"=>"Basic cmF0YXRvc2s6dGVzdF9wYXNz"}, nil,503
          end
          @user.update_from_gram
        end 

        it "is not synced with gram" do
          expect(@user.synced_with_gram).to eq (false)
        end
      end
    end

    context "doesn't have an hruid" do
      before :each do
        @user = FactoryGirl.create(:user,hruid:nil)
        @user.update_from_gram
      end

      it "return false" do
        expect(@user.synced_with_gram).to eq (false)
      end

      it "doesn't try to connect to GrAM API" do
      end
    end
  end

  describe "is find via omniauth" do

    before :each do
      @omniauth_data = OmniAuth::AuthHash.new(omniauth_hash({'extra' =>{'firstname' => 'Alex', 'lastname' => 'NARBON'},'infos'=>{'email' => 'alexandre.narbonne+CAS@gadz.org'}}))
      @gram_get_account_response= gram_account_mocked

      ActiveResource::HttpMock.respond_to do |mock|
        mock.get '/api/v1/accounts/alexandre.narbonne.2011/accounts.json', {'Accept' => 'application/json', "Authorization"=>"Basic cmF0YXRvc2s6dGVzdF9wYXNz"}, @gram_get_account_response, 200
      end

    end

    context "and user already exist" do
      before :each do
        @user = FactoryGirl.create(:user,
                                   hruid:"alexandre.narbonne.2011",
                                   email:"coucou@text.com",
                                   firstname:"Alex",
                                   lastname:"Narbon")
      end

      it "return the user find by hruid" do
        expect(User.omniauth(@omniauth_data)).to eq(@user)
      end
    end

    context "and user doesn't exist" do
      describe "create a new user with omniauth data" do
        context "and data are valid" do
          it "create a new user" do
            expect{User.omniauth(@omniauth_data)}.to change(User,:count).by(1)
          end

          it "return a user" do
            expect(User.omniauth(@omniauth_data).class).to eq(User)
          end
        end

        context "and data are invalid" do
          before :each do
            @omniauth_data = OmniAuth::AuthHash.new(omniauth_hash({'info'=>{'email'=>'invalid_email'}}))
          end
          it "return nil" do
            expect(User.omniauth(@omniauth_data)).to eq(nil)
          end

          it "log an error" do
            lo=fake(:logger)
            Rails.logger= lo
            expect(lo).to have_received(:error)
            User.omniauth(@omniauth_data)
          end
        end
      end
    end

    describe "update with gram info" do

      context "can connect to gram API" do
        before :each do
          @gram_get_account_mocked_response= gram_account_mocked({'firstname' => 'Alexandre', 'lastname' => 'NARBONNE' ,'email' => 'alexandre.narbonne@gadz.org'})
          ActiveResource::HttpMock.respond_to do |mock|
            mock.get '/api/v1/accounts/alexandre.narbonne.2011/accounts.json', {'Accept' => 'application/json', "Authorization"=>"Basic cmF0YXRvc2s6dGVzdF9wYXNz"}, @gram_get_account_mocked_response, 200
          end
        end

        describe "update with gram info" do
          before :each do
            @user=User.omniauth(@omniauth_data)
          end 
          it "update email" do
            expect(@user.email).to eq("alexandre.narbonne@gadz.org")
          end
          it "update firstname" do
            expect(@user.firstname).to eq("Alexandre")
          end
          it "update lastname" do
            expect(@user.lastname).to eq("NARBONNE")
          end
        end
      end

      context "cannot connect to gram API" do
        before :each do
          ActiveResource::HttpMock.respond_to do |mock|
            mock.get '/api/v1/accounts/alexandre.narbonne.2011/accounts.json', {'Accept' => 'application/json', "Authorization"=>"Basic cmF0YXRvc2s6dGVzdF9wYXNz"}, nil,503
          end
          @user=User.omniauth(@omniauth_data)
        end 

        it "is not synced with gram" do
          expect(@user.synced_with_gram).to eq (false)
        end

        it "log an error" do
          lo=fake(:logger)
          Rails.logger= lo
          expect(lo).to have_received(:error)
          User.omniauth(@omniauth_data)
        end
      end
    end
  end

  it "return a fullname" do
    user=FactoryGirl.build(:user, firstname: "Alexandre", lastname:"Narbonne")
    expect(user.fullname).to eq("Alexandre Narbonne")
  end

end
