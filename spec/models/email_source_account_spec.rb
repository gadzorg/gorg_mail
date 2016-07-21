require 'rails_helper'

RSpec.describe EmailSourceAccount, type: :model do


  it "has an empty database and User too" do
    expect(EmailSourceAccount.count).to eq(0)
    expect(User.count).to eq(0)
  end

  it {is_expected.to validate_uniqueness_of(:email).scoped_to(:email_virtual_domain_id)}

  describe "Standard alias generation" do
    @user = FactoryGirl.create(:user,
                               hruid:"alex.narbon.2013",
                               email:"coucou2@text.com",
                               firstname:"Alex",
                               lastname:"Narbon")
    puts @user.hruid
    EmailSourceAccount.generate_standard_aliases_for(@user)
    it "generate {prenom}.{nom}@gadz.org" do
      expect(@user.email_source_accounts.map(&:full_email_address)).to include("alex.narbon@gadz.org")
    end
    it "generate {prenom}.{nom}@gadzarts.org" do
      expect(@user.email_source_accounts.map(&:full_email_address)).to include("alex.narbon@gadzarts.org")
    end
    it "generate {prenom}.{nom}@m4am.net" do
      expect(@user.email_source_accounts.map(&:full_email_address)).to include("alex.narbon@m4am.net")
    end
    it "user {hruid} instead of {prenom}.{nom} if homonys are present" do
      @user = FactoryGirl.create(:user,
                                 hruid:"alex.narbon.2012",
                                 email:"coucou3@text.com",
                                 firstname:"Alex",
                                 lastname:"Narbon")
      expect(@user.email_source_accounts.map(&:full_email_address)).to include("alex.narbon.2012@gadz.org")
    end
  end

end