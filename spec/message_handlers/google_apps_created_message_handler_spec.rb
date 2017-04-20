require 'rails_helper'
require "ostruct"

RSpec.describe GoogleAppsCreatedMessageHandler, type: :message_handler do


  subject {GoogleAppsCreatedMessageHandler.new(message)}
  let(:message) {GorgService::ReplyMessage.new(soa_version: "2.0",status_code: status_code,data: data, error_type: error_type, error_name: error_name)}
  let(:status_code) {200}
  let(:error_type) {nil}
  let(:error_name) {nil}

  let(:user) {FactoryGirl.create(:user_with_unconfirmed_googleapps)}
  let(:google_id) {"123456789132456789"}

  context "Success" do
    let(:status_code) {200}

    context "invalid payload" do
      let(:data) { { invalid: "data"}}

      it " does not raise an InvalidData error" do
        expect{subject}.to raise_exception
      end
    end

    context "valid payload" do
      let(:data) {{
          uuid: user.uuid,
          google_id: google_id
      }}

      it "accepts payload" do
        expect{subject}.not_to raise_exception
      end

      it "confirms and validates google apps redirection of user" do
        subject
        expect(user.google_apps).to have_attributes(
                                        flag: 'active',
                                        confirmed: true
                                    )
      end
    end
  end






  context "Error code 400" do



    let(:status_code) {400}
    let(:error_type) {'hardfail'}

    context "invalid payload" do
      let(:data) { { invalid: "data"}}

      it " does not raise an InvalidData error" do
        expect{subject}.not_to raise_exception
      end
    end

    shared_examples "error processing" do

      before(:each) do
        expect(JiraIssue).to receive(:create).and_return(OpenStruct.new(key: 'MRM-1234', self: "https://jira.gadz.org/rest/api/2/issue/38613"))
        subject
      end

      it "set googleapps to broken" do
        expect(user.google_apps).to have_attributes(
                                        flag: 'broken'
                                    )
      end
      it "does not confirms google apps" do
        expect(user.google_apps).to have_attributes(
                                        confirmed: false
                                    )
      end

      it "set broken_info to Jira Issue Key" do
        expect(user.google_apps).to have_attributes(
                                        broken_info: 'Voir MRM-1234'
                                    )
      end
    end

    context "ExistingGoogleAccount" do

      include_examples "error processing"

      let(:error_name) {"ExistingGoogleAccount"}
      let(:data) {{
          error_message:"Google Account john.doe@gadz.org already exists",
          debug_message: "#<Google::Apis::ClientError: duplicate: Entity already exists.>",
          error_data: {uuid: user.uuid},
      }}
    end

    context "UnableToSaveGramUser" do

      let(:status_code) {500}

      include_examples "error processing"

      let(:error_name) {"UnableToSaveGramUser"}
      let(:data) {{
          error_message:"Unable to update GrAM gapps_id of account #{user.uuid}",
          debug_message: nil,
          error_data: {uuid: user.uuid},
      }}

    end

    context "GoogleAccountAlreadyRegisteredInGrAM" do

      include_examples "error processing"

      let(:error_name) {"GoogleAccountAlreadyRegisteredInGrAM"}
      let(:data) {{
          error_message:"Account #{user.uuid} already have a google acount registrered",
          debug_message: nil,
          error_data: {uuid: user.uuid},
      }}
    end
  end


end