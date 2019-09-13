require 'rails_helper'

RSpec.describe EmailSourceAccount, type: :model do


  it "has an empty database and User too" do
    expect(EmailSourceAccount.count).to eq(0)
    expect(User.count).to eq(0)
  end

  it {is_expected.to validate_uniqueness_of(:email).scoped_to(:email_virtual_domain_id)}
  it {is_expected.to validate_presence_of(:email)}
  it {is_expected.to validate_presence_of(:email_virtual_domain)}
  it {is_expected.to validate_presence_of(:user)}

=begin
  it "invalidate multiple primary email by user" do
    user = create(:user, hruid:"alex.narbon.2010", email:"coucou4@text.com", firstname:"Alex", lastname:"Narbon") create(:email_source_account, primary: true, user_id: user.id)
    second_primary_email = build(:email_source_account, primary: true, user_id: user.id)
    user.email_source_accounts.create(email: "test", email_virtual_domain_id: "1")
    expect(second_primary_email).not_to be_valid
  end
=end

  describe "Standard alias generation" do
    #   @user = create(:user,
    #                              hruid:"alex.narbon.2013",
    #                              email:"coucou2@text.com",
    #                              firstname:"Alex",
    #                              lastname:"Narbon")
    let(:user)  { create(:user, hruid:"alex.narbon.2013", email:"coucou2@text.com", firstname:"Alex", lastname:"Narbon") }
  before {EmailSourceAccount.create_standard_aliases_for(user) }

  it "can call generation function" do
    EmailSourceAccount.create_standard_aliases_for(user)
  end


  it "generate {prenom}.{nom}@gadz.org if available" do
    Rails.logger.debug user.email_source_accounts.map(&:full_email_address)
    expect(user.email_source_accounts.map(&:full_email_address)).to include("alex.narbon@gadz.org")
  end
  it "generate {prenom}.{nom}@gadzarts.org if available" do
    expect(user.email_source_accounts.map(&:full_email_address)).to include("alex.narbon@gadzarts.org")
  end
  it "generate {prenom}.{nom}@m4am.net if available" do
    expect(user.email_source_accounts.map(&:full_email_address)).to include("alex.narbon@m4am.net")
  end

  let(:user2)  { create(:user, hruid:"alex.narbon.2012", email:"coucou3@text.com", firstname:"Alex", lastname:"Narbon") }
  before {EmailSourceAccount.create_standard_aliases_for(user2) }
  it "user {hruid} instead of {prenom}.{nom} if homonys are present" do
    # @user = create(:user,
    #                              hruid:"alex.narbon.2012",
    #                              email:"coucou3@text.com",
    #                              firstname:"Alex",
    #                              lastname:"Narbon")
      expect(user2.email_source_accounts.map(&:full_email_address)).to include("alex.narbon.2012@gadz.org")
    end
  end

  describe "search an email address" do

    let(:user){ create(:user_with_addresses)}
    let(:esa) {user.email_source_accounts.first}

    it "find an address" do
      expect(EmailSourceAccount.find_by_full_email(esa.to_s)).to eq(esa)
    end

    it "return nil when not found" do
      expect(EmailSourceAccount.find_by_full_email("not_existent")).to be_nil
    end

    it "find with domain alias" do
      domain=esa.email_virtual_domain
      domain.aliases.create(name:"example.org")
      query="#{esa.email}@example.org"
      expect(EmailSourceAccount.find_by_full_email(query)).to eq(esa)
    end

  end


end