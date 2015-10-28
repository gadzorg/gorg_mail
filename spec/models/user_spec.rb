require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:user)).to be_valid
  end
  it "is invalid if there is no hruid" do
    expect(FactoryGirl.build(:user, hruid: nil)).not_to be_valid
  end
  it "is invalid if hruid already exist" do
    FactoryGirl.create(:user,hruid:"alexandre.narbonne.2011")
    expect(FactoryGirl.build(:user,hruid:"alexandre.narbonne.2011")).not_to be_valid
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
    before :each do
      @user = FactoryGirl.create(:user,hruid:"alexandre.narbonne.2011")
      @user.update_from_gram
    end
    context "can connect to gram" do
      it "update email with value from GrAM" do #TODO

      end
      it "update firstname with value from GrAM" do #TODO

      end
      it "update lastname with value from GrAM" do #TODO

      end
      it "is synced with gram" do
        expect(@user.synced_with_gram).to eq (true)
      end
    end

    context "cannont connect to gram" do
      it "is not synced with gram" do
        expect(@user.synced_with_gram).to eq (false)
      end
    end
  end

  describe "is find via omniauth" do

    before :each do
      @omniauth_data = OmniAuth::AuthHash.new({"provider"=>"GadzOrg", "uid"=>"alexandra.narbonnette.ext.2", "info"=>{"email"=>"alexandre.narbonne+986532@gadz.org", "name"=>"alexandre.narbonne+986532@gadz.org"}, "credentials"=>{"ticket"=>"ST-120-SOPFsbPYKwW1qx3ax0NK-cas"}, "extra"=>{"user"=>"alexandra.narbonnette.ext.2", "username"=>"alexandra.narbonnette.ext.2", "lastname"=>"NARBONNETTE", "firstname"=>"Alexandra", "soce_id"=>"84189"}})
    end

    context "and user already exist" do
      before :each do
        @user = FactoryGirl.create(:user,
                                   hruid:"alexandra.narbonnette.ext.2",
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
            @omniauth_data = OmniAuth::AuthHash.new({"provider"=>"GadzOrg", "uid"=>"", "info"=>{"email"=>"alexandre.narbonne+986532@gadz.org", "name"=>"alexandre.narbonne+986532@gadz.org"}, "credentials"=>{"ticket"=>"ST-120-SOPFsbPYKwW1qx3ax0NK-cas"}, "extra"=>{"user"=>"alexandra.narbonnette.ext.2", "username"=>"alexandra.narbonnette.ext.2", "lastname"=>"NARBONNETTE", "firstname"=>"Alexandra", "soce_id"=>"84189"}})
          end
          it "return nil" do
            expect(User.omniauth(@omniauth_data)).to eq(nil)
          end

          it "log an error" do
            expect(Rails.logger).to receive(:error)
            User.omniauth(@omniauth_data)
          end


        end
      end
    end
    describe "update with gram info" do
      context "can connect to gram API" do
        describe "update with gram info" do
          it "update email"
          it "update firstname"
          it "update lastname"
        end


      end
      context "cannot connect to gram API" do
        it "log an error" do
          expect(Rails.logger).to receive(:error)
          User.omniauth(@omniauth_data)
        end

      end
    end
  end
  it "return a full name" do
    user=FactoryGirl.build(:user, firstname: "Alexandre", lastname:"Narbonne")
    expect(user.full_name).to eq("Alexandre Narbonne")
  end
end
