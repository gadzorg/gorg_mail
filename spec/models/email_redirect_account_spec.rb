require 'rails_helper'

RSpec.describe EmailRedirectAccount, type: :model do

  it "has a valid Factory" do
    expect(FactoryGirl.build(:email_redirect_account)).to be_valid
  end

  describe "validations" do

    it {is_expected.to validate_presence_of(:redirect)}
    it {is_expected.to validate_uniqueness_of(:redirect).scoped_to(:user_id)}

    #email format validation
    it {is_expected.to allow_value('alex.narbo@hotmail.com').for(:redirect)}
    it {is_expected.not_to allow_value('alex.narbo').for(:redirect)}
    it {is_expected.not_to allow_value('alex.narbo@hotmail').for(:redirect)}

    describe "does not accept internal email addresses as redirection" do
      it "does not validate" do
        expect(FactoryGirl.build(:email_redirect_account,redirect: "local@#{EmailVirtualDomain.first.name}")).not_to be_valid
      end

      it "add an error message" do
        record=FactoryGirl.build(:email_redirect_account,redirect: "local@#{EmailVirtualDomain.first.name}")
        record.valid?

        expect(record.errors.messages[:redirect]).to include(I18n.t('activerecord.validations.email_redirect_account.domain'))
      end
    end

    describe "validate occurencies of 'active flags'" do
      it "does not validate when their is more than #{Configurable.max_actives_era} ERA per user" do
        Configurable.max_actives_era.times{FactoryGirl.create(:email_redirect_account,flag: 'active',type_redir: "smtp", user_id: 1)}
        expect(FactoryGirl.build(:email_redirect_account,flag: 'active',type_redir: "smtp", user_id: 1)).not_to be_valid
      end

      it "validates only on smtp" do
        Configurable.max_actives_era.times{FactoryGirl.create(:email_redirect_account,flag: 'active',type_redir: "googleapps", user_id: 1)}
        expect(FactoryGirl.build(:email_redirect_account,flag: 'active',type_redir: "smtp", user_id: 1)).to be_valid
      end
    end
  end
end