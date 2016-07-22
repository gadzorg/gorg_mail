# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  hruid                  :string
#  firstname              :string
#  lastname               :string
#  role_id                :integer
#  last_gram_sync_at      :datetime
#

require 'rails_helper'


RSpec.describe EmailSourceAccountGenerator, type: :service do

  it "has default domains" do
    expect(EmailSourceAccountGenerator::DEFAULT_DOMAIN).to eq('gadz.org')
  end

  describe "Emails adresses generation" do

    let(:user){FactoryGirl.create(:user, firstname: "John", lastname: "Doe", hruid: "john.doe.2011")}
    let(:esas){user.email_source_accounts.map{|esa| esa.to_s}}

    before(:each) do
      @gorg_d=EmailVirtualDomain.create(
        :name => "gadz.org",
        )
      @gadzorg_d=EmailVirtualDomain.create(
        :name => "gadzarts.org",
        )
      @gorg_d.update_attribute(:aliasing, @gorg_d.id)
      @gadzorg_d.update_attribute(:aliasing, @gorg_d.id)
    end

    it "returns an array of email source account" do
      response=EmailSourceAccountGenerator.new(user).generate

      expect(response).to be_a_kind_of(ActiveRecord::Associations::CollectionProxy)
      expect(response).to all(be_an_instance_of(EmailSourceAccount))
    end

    context 'with no homonym' do

      before(:each) do
        EmailSourceAccountGenerator.new(user).generate
      end

      it "generate first_name.last_name@gadz.org" do
        expect(esas).to include('john.doe@gadz.org')
      end


      it "generate first_name.last_name@gadzarts.org" do
        expect(esas).to include('john.doe@gadzarts.org')
      end
    end

    context 'with existing homonym' do
      before(:each) do
        u=FactoryGirl.create(:user, firstname: "John", lastname: "Doe", hruid: "john.doe.2009")
        EmailSourceAccountGenerator.new(u).generate
        EmailSourceAccountGenerator.new(user).generate
      end

      it "generate hruid@gadz.org" do
        expect(esas).to include('john.doe.2011@gadz.org')
      end

      it "generate hruid@gadzarts.org" do
        expect(esas).to include('john.doe.2011@gadzarts.org')
      end

      it "doesn't generate first_name.last_name@gadz.org" do
        expect(esas).not_to include('john.doe@gadz.org')
      end

      it "doesn't generate first_name.last_name@gadzarts.org" do
        expect(esas).not_to include('john.doe@gadzarts.org')
      end
    end

    context 'with existing email source account' do

      before(:each) do
        @esa=user.email_source_accounts.create(
          email: "alexandre.narbonne",
          email_virtual_domain: @gadzorg_d
          )       
        @response=EmailSourceAccountGenerator.new(user).generate
      end

      it "doesn't add email source account" do
        expect(user.email_source_accounts).to match_array([@esa])
      end

      it "returns false" do
        expect(@response).to be false
      end

    end

  end
end
