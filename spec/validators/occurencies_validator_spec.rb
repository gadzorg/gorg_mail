require 'rails_helper'

RSpec.describe OccurenciesValidator, type: :validator do

  subject { OccurenciesValidator.new(options.merge({attributes: [attribute]})) }
  let(:attribute) {:flag}

  context "on valid record" do
    let(:options) {{max: 2}}
    let(:record) {FactoryGirl.build(:email_redirect_account,attribute => 'active', user_id: 1, type_redir: "smtp")}

    it "validates record" do

      subject.validate_each(record,:flag,'active')

      expect(record.errors).to match_array([])
    end

    it 'validates occurencies of a single value' do
      2.times do
        FactoryGirl.create(:email_redirect_account,attribute => 'broken')
      end

      subject.validate_each(record,:flag,'active')

      expect(record.errors).to match_array([])
    end

    describe "with 'only' option" do
      let(:options) {{max: 2, only: 'active'}}

      it "validate other values" do
        2.times do
          FactoryGirl.create(:email_redirect_account,attribute => 'broken')
        end

        subject.validate_each(record,:flag,'broken')

        expect(record.errors).to match_array([])
      end

    end

    describe "with 'scope' option" do
      let(:options) {{max: 2, scope: :user_id}}

      it "validate other values" do
        2.times do
          FactoryGirl.create(:email_redirect_account,attribute => 'active', user_id: 2)
        end

        subject.validate_each(record,:flag,'active')

        expect(record.errors).to match_array([])
      end

    end

    describe "with 'where' option" do
      let(:options) {{max: 2, where: {type_redir: "smtp"}}}

      it "validate only on where" do
        2.times do
          FactoryGirl.create(:email_redirect_account,attribute => 'active', type_redir: "googleapps")
        end

        subject.validate_each(record,:flag,'active')

        expect(record.errors).to match_array([])
      end

    end

  end

  context 'too much records' do
    let(:options) {{max: 2}}
    let(:record) {FactoryGirl.build(:email_redirect_account,attribute => 'active')}

    before(:each) { 2.times{FactoryGirl.create(:email_redirect_account,attribute => 'active')} }

    it "add an error" do
      expect{ subject.validate_each(record,:flag,'active') }.to change{record.errors.count}.by(1)
    end

    it "add an error message" do
      subject.validate_each(record,:flag,'active')
      expect(record.errors.messages[attribute]).to include("is already used 2 times (max: 2)")
    end
  end

end