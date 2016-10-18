require 'rails_helper'


RSpec.describe MailingListsService, type: :service do
  fake(:message_sender) { GorgMessageSender }


  let(:ml) {FactoryGirl.create(:ml_list)}
  let (:mailing_lists_service) {MailingListsService.new(ml, message_sender: message_sender)}

  describe "send mailling update message" do
    it "send a message on update" do
      mailing_lists_service.update
      expect(message_sender).to have_received.send_message(any_args)
    end

    it "send a message on delete" do
      mailing_lists_service.delete
      expect(message_sender).to have_received.send_message(any_args)
    end
  end

  describe "no sync block" do
    it "does not call Message sender on update" do
      MailingListsService.no_sync_block do
        mailing_lists_service.update
      end
      expect(message_sender).not_to have_received.send_message(any_args)
    end

    it "does not call Message sender on delete" do
      MailingListsService.no_sync_block do
        mailing_lists_service.delete
      end
      expect(message_sender).not_to have_received.send_message(any_args)
    end
  end


end