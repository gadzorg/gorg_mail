require 'rails_helper'

RSpec.describe SetupSubscriptionService, type: :service do
  fake(:message_sender) { GorgService::Producer }

  describe '#mailing_lists' do
    before :each do
      emails = [
        'foobar@gadz.org', 
        'tbk.bo@gadz.org',
        'tbk.kin@gadz.org',  
        'bo217@gadz.org', 
        'kin217@gadz.org', 
        'bo198@gadz.org', 
        'info-pg@gadz.org',
        'info-ue@gadz.org'
      ]

      emails.each do |email|
        FactoryGirl.create(:ml_list, name: email, email: email)
      end
    end

    context "for a gadz after 2000" do
      let(:user) { FactoryGirl.create(:user, gadz_centre_principal: "bo", gadz_proms_principale: "2017") }
      let(:service) { SetupSubscriptionService.new(user) }

      it "includes expected mailing list (inc. 2xx)" do
        expect(service.mailing_lists.size).to eq(3)

        mailing_list_emails = service.mailing_lists.values.map(&:email)

        expect(mailing_list_emails).to include("bo217@gadz.org")
        expect(mailing_list_emails).to include("tbk.bo@gadz.org")
        expect(mailing_list_emails).to include("info-pg@gadz.org")
      end
    end

    context "for a gadz before 2000" do
      let(:user) { FactoryGirl.create(:user, gadz_centre_principal: "bo", gadz_proms_principale: "1998") }
      let(:service) { SetupSubscriptionService.new(user) }

      it "includes expected mailing list (inc. 1xx)" do
        expect(service.mailing_lists.size).to eq(3)

        mailing_list_emails = service.mailing_lists.values.map(&:email)

        expect(mailing_list_emails).to include("bo198@gadz.org")
        expect(mailing_list_emails).to include("tbk.bo@gadz.org")
        expect(mailing_list_emails).to include("info-pg@gadz.org")
      end
    end

    context "for a gadz of Aix(ai)" do
      let(:user) { FactoryGirl.create(:user, gadz_centre_principal: "ai", gadz_proms_principale: "2017") }
      let(:service) { SetupSubscriptionService.new(user) }

      it "includes expected mailing list (inc. ai/kin exception)" do
        expect(service.mailing_lists.size).to eq(3)

        mailing_list_emails = service.mailing_lists.values.map(&:email)

        expect(mailing_list_emails).to include("kin217@gadz.org")
        expect(mailing_list_emails).to include("tbk.kin@gadz.org")
        expect(mailing_list_emails).to include("info-pg@gadz.org")
      end
    end

    context "for a non gadz" do
      let(:user) { FactoryGirl.create(:user, gadz_centre_principal: "", gadz_proms_principale: "") }
      let(:service) { SetupSubscriptionService.new(user) }

      it "should be empty" do
        expect(service.mailing_lists.size).to eq(1)
      end
    end
  end
  
  describe '#do_subscribe' do
    let(:list) { FactoryGirl.create(:ml_list, email: 'foobar@gadz.org') }
    let(:user) { FactoryGirl.create(:user) }
    let(:service) { SetupSubscriptionService.new(user) }

    it "subscribes to built mailing_lists" do
      # service.stub(:mailing_lists) { [list] }
      allow(service).to receive(:mailing_lists).and_return([list])

      skip("Aucun test existant sur le MailingListSubscriptionService")
      service.do_subscribe

      expect(list.members).to include(user)
    end
  end

  ### Private methods should not be tested: TODO move it to dedicated service (GadzMailingList)

  describe "#promotion_mailing_list_email" do
    let(:user) { FactoryGirl.create(:user, gadz_centre_principal: "bo", gadz_proms_principale: "2017") }
    let(:service) { SetupSubscriptionService.new(user) }

    it "returns proms mailing list, like xxNNN@gadz.org" do
      expect(service.send(:proms_mailing_list_email)).to eq("bo217@gadz.org")
    end
  end

  describe "#tabagns_mailing_list_email" do
    let(:user) { FactoryGirl.create(:user, gadz_centre_principal: "bo", gadz_proms_principale: "2017") }
    let(:service) { SetupSubscriptionService.new(user) }

    it "return tabagns mailing list, like tbk.xx@gadz.org" do
      expect(service.send(:tabagns_mailing_list_email)).to eq("tbk.bo@gadz.org")
    end
  end

  ### Private methods should not be tested: TODO move it to dedicated service (User)

  describe "#gadz_tabagns" do
    describe "for a gadz whose tabagns is not Aix" do
      let(:user) { FactoryGirl.create(:user, gadz_centre_principal: "bo") }
      let(:service) { SetupSubscriptionService.new(user) }

      it "return tabagns by default" do
        expect(service.send(:gadz_tabagns)).to eq("bo")
      end
    end

    describe "for a gadz of Aix" do
      let(:user) { FactoryGirl.create(:user, gadz_centre_principal: "ai") }
      let(:service) { SetupSubscriptionService.new(user) }

      it "return kin (a rule has always an exception)" do
        expect(service.send(:gadz_tabagns)).to eq("kin")
      end
    end
  end

  describe "#gadz_ans" do
    describe "for a gadz after 2000" do
      let(:user) { FactoryGirl.create(:user, gadz_proms_principale: "2017") }
      let(:service) { SetupSubscriptionService.new(user) }

      it "return ans like 2xx" do
        expect(service.send(:gadz_ans)).to eq("217")
      end
    end

    describe "for a gadz before 2000" do
      let(:user) { FactoryGirl.create(:user, gadz_proms_principale: "1998") }
      let(:service) { SetupSubscriptionService.new(user) }

      it "return ans like 1xx" do
        expect(service.send(:gadz_ans)).to eq("198")
      end
    end
  end
end