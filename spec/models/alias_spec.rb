require 'rails_helper'

RSpec.describe Alias, type: :model do

  describe "validation" do
    it "is not valid with an non existent id" do
      expect(FactoryGirl.build(:alias, email_virtual_domain_id: 157)).not_to be_valid
    end
  end

  describe 'search' do

    let!(:alias1) { FactoryGirl.create(:alias, email: "emailA1", redirect: "redirect1@exampleC.com") }
    let!(:alias2) { FactoryGirl.create(:alias, email: "emailA2", redirect: "redirect2@exampleD.com") }
    let!(:alias3) { FactoryGirl.create(:alias, email: "emailB3", redirect: "redirect3@exampleD.com") }

    it "found none" do
      expect(Alias.search("not_existent")).to match_array([])
    end

    it "search in source email" do
      expect(Alias.search("emailA1@#{EmailVirtualDomain.find(1).name}")).to match_array([alias1])
    end

    describe "search in local part of source email" do
      it "found one" do
        expect(Alias.search("emailA1")).to match_array([alias1])
      end
      it "found many" do
        expect(Alias.search("emailA")).to match_array([alias1,alias2])
      end
    end
    describe "search in domain part of source email" do
      it "found many" do
        expect(Alias.search(EmailVirtualDomain.find(1).name)).to match_array([alias1,alias2,alias3])
      end
    end

    it "search in redirect email" do
      expect(Alias.search("redirect1@exampleC.com")).to match_array([alias1])
    end

    describe "search in local part of redirect email" do
      it "found one" do
        expect(Alias.search("redirect1")).to match_array([alias1])
      end
      it "found many" do
        expect(Alias.search("redirect")).to match_array([alias1,alias2,alias3])
      end
    end
    describe "search in domain part of redirect email" do
      it "found one" do
        expect(Alias.search("exampleC.com")).to match_array([alias1])
      end
      it "found many" do
        expect(Alias.search("exampleD")).to match_array([alias2,alias3])
      end
    end

  end

end