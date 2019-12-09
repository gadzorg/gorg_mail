require 'rails_helper'

RSpec.describe Ml::List, type: :model do
  it "has a valid factory" do
    expect(build(:ml_list)).to be_valid
  end

  it {is_expected.to validate_presence_of(:name)}
  it {is_expected.to validate_presence_of(:email)}

  it { should allow_value("open").for(:diffusion_policy) }
  it { should allow_value("closed").for(:diffusion_policy) }
  it { should allow_value("moderated").for(:diffusion_policy) }
  it { should_not allow_value(nil).for(:diffusion_policy) }

  Ml::List.inscription_policy_list.each do |p|
    it { should allow_value(p).for(:inscription_policy) }
  end
  it { should_not allow_value(nil).for(:inscription_policy) }

  it { should allow_value(true).for(:is_archived) }
  it { should allow_value(false).for(:is_archived) }
  it { should_not allow_value(nil).for(:is_archived) }

  it {is_expected.to validate_presence_of(:message_max_bytes_size)}

  it "handle group uuid" do
    expect(build(:ml_list, group_uuid:SecureRandom.uuid).belong_to_group?).to be_truthy
  end

  it "handle no group uuid" do
    expect(build(:ml_list).belong_to_group?).to be_falsey
  end

  describe "returns all emails"do

    it "returns primary emails" do
      ml= create(:ml_list)
      users= create_list(:user_with_addresses,4)
      users.each{|u| ml.add_user(u)}

      expect(ml.all_emails).to match_array(users.map{|u| u.primary_email.to_s})
    end

    it "returns primary emails of members only" do
      ml= create(:ml_list)
      users= create_list(:user_with_addresses,4)
      banned_users= create_list(:user_with_addresses,4)
      users.each{|u| ml.add_user(u)}
      banned_users.each{|u| ml.add_user(u)&&ml.set_role(u, :banned)}

      expect(ml.all_emails).to match_array(users.map{|u| u.primary_email.to_s})
    end

    it "returns contact emails" do
      ml= create(:ml_list)
      users= create_list(:user_with_addresses,4)
      users_without_primary= create_list(:user,2,:non_gadz)
      users.each{|u| ml.add_user(u)}
      users_without_primary.each{|u| ml.add_user(u)}

      expect(ml.all_emails).to match_array(users.map{|u| u.primary_email.to_s}+users_without_primary.map(&:email))
    end


  end

  describe 'search' do

    before(:each) do
      @list1= create(:ml_list, name: 'Ma liste 1', email: 'maliste1@gadz.org')
      @list2= create(:ml_list, name: 'Ma liste 2', email: 'maliste2@gadz.org')
      @list3= create(:ml_list, name: 'Une autre liste', email: 'une.autre.liste@gadz.org')
    end

    it "return all on nil query" do
      expect(Ml::List.search(nil)).to match_array([@list1,@list2,@list3])
    end

    it "search by name" do
      expect(Ml::List.search('Ma liste')).to match_array([@list1,@list2])
      expect(Ml::List.search('autre liste')).to match_array([@list3])
    end

    it "is case incensitive" do
      expect(Ml::List.search('MA liSTe')).to match_array([@list1,@list2])
    end

    it "search by email" do
      expect(Ml::List.search('maliste')).to match_array([@list1,@list2])
      expect(Ml::List.search('@gadz.org')).to match_array([@list1,@list2,@list3])
      expect(Ml::List.search('maliste1')).to match_array([@list1])
    end

  end


end

