require 'rails_helper'

RSpec.describe SetupService, type: :service do
  describe '#need_setup?' do
    context 'when gadz' do
      let(:user) { FactoryGirl.create(:user, is_gadz: true) }
      let(:service) { SetupService.new(user) }

      it "should be true" do
        expect(service.need_setup?).to be true
      end
    end

    context 'when not  gadz' do
      let(:user) { FactoryGirl.create(:user, is_gadz: false) }
      let(:service) { SetupService.new(user) }

      it "should be false" do
        expect(service.need_setup?).to be false
      end
    end
  end

  describe '#prepare' do
    it 'should create_standard_aliases_for'
  end

  describe '#process_form' do
    it 'should create_email_redirect_account'
    it 'should create_google_apps'
    it 'should subscribe_to_default_mailing_lists'
  end
end