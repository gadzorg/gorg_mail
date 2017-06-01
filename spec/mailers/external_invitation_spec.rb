require "rails_helper"

RSpec.describe ExternalInvitation, type: :mailer do
  describe "send_invitation" do
    let(:mail) { ExternalInvitation.send_invitation }

    it "renders the headers" do
      expect(mail.subject).to eq("Send invitation")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
