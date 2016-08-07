require 'rails_helper'


RSpec.describe GoogleApps, type: :service do

  describe "Add Google Apps account to user" do
    let(:user){FactoryGirl.create(:user, firstname: "John", lastname: "Doe", hruid: "john.doe.2011")}
    before(:each) do
      GoogleApps.new(user).generate
    end

    it "Send Google Apps creation message to RabbitMQ"
    it "Create redirection to the google apps address" do
      expect(user.email_redirect_accounts.map(&:redirect)).to include('john.doe@gadz.fr')
    end
    it "create redirection with gapps flag" do
      expect(user.email_redirect_accounts.find_by(redirect: 'john.doe@gadz.fr').type_redir).to eq('gapps')

    end


  end
end
