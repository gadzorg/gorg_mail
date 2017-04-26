require 'rails_helper'


RSpec.describe GoogleApps, type: :service do

  describe "Add Google Apps account to user" do
    fake(:message_sender) { GorgService::Producer }

    let(:user){FactoryGirl.create(:user, firstname: "John", lastname: "Doe", hruid: "john.doe.2011")}

    before(:each) do
      EmailSourceAccountGenerator.new(user).generate
      GoogleApps.new(user).generate
    end

    it "Create redirection to the google apps address" do
      expect(user.email_redirect_accounts.map(&:redirect)).to include('john.doe@gadz.fr')
    end
    it "create redirection with gapps flag" do
      expect(user.email_redirect_accounts.find_by(redirect: 'john.doe@gadz.fr').type_redir).to eq('googleapps')

    end

    it "Request a message sending to the message sender for Google Apps creation" do
      gapps_email = user.primary_email.to_s
      message = {
          gram_account_uuid: user.uuid,
          primary_email: gapps_email,
          aliases:  user.email_source_accounts.map(&:to_s)-['john.doe@gadz.org']
      }
      expect(message_sender).to receive(:publish_message).with(a_kind_of(GorgService::Message).and(an_object_having_attributes(data: message)))
      gapps = GoogleApps.new(user, message_sender: message_sender).generate
    end

    it "Request a message sending to the message sender for Google Apps update" do
      message = {
          gram_account_uuid: user.uuid,
          aliases:  user.email_source_accounts.map(&:to_s)-['john.doe@gadz.org'],
          primary_email: "john.doe@gadz.org"
      }
      expect(message_sender).to receive(:publish_message).with(a_kind_of(GorgService::Message).and(an_object_having_attributes(data: message)))
      gapps = GoogleApps.new(user, message_sender: message_sender).update
    end



  end
end
