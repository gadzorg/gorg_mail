require 'rails_helper'

RSpec.describe Ml::List, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:ml_list)).to be_valid
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
    expect(FactoryGirl.build(:ml_list, group_uuid:SecureRandom.uuid).belong_to_group?).to be_truthy
  end

  it "handle no group uuid" do
    expect(FactoryGirl.build(:ml_list).belong_to_group?).to be_falsey
  end
end
