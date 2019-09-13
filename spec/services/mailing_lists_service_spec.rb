require 'rails_helper'


RSpec.describe MailingListsService, type: :service do
  let(:message_sender) { instance_double("GorgService::Producer") }


  let(:ml) {FactoryGirl.create(:ml_list)}
  let (:mailing_lists_service) {MailingListsService.new(ml, message_sender: message_sender)}

  describe "send mailling update message" do
    it "send a message on update" do
      expect(message_sender).to receive(:publish_message).with(a_kind_of(GorgService::Message))
      mailing_lists_service.update
    end

    it "send a message on delete" do
      expect(message_sender).to receive(:publish_message).with(a_kind_of(GorgService::Message))
      mailing_lists_service.delete
    end
  end

  describe "no sync block" do
    it "does not call Message sender on update" do
      expect(message_sender).not_to receive(:publish_message).with(a_kind_of(GorgService::Message))
      MailingListsService.no_sync_block do
        mailing_lists_service.update
      end
    end

    it "does not call Message sender on delete" do
      expect(message_sender).not_to receive(:publish_message).with(a_kind_of(GorgService::Message))
      MailingListsService.no_sync_block do
        mailing_lists_service.delete
      end
    end
  end
end