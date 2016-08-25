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

  it { should allow_value("open").for(:inscription_policy) }
  it { should allow_value("closed").for(:inscription_policy) }
  it { should allow_value("in_group").for(:inscription_policy) }
  it { should_not allow_value(nil).for(:inscription_policy) }


  it { should allow_value(true).for(:is_public) }
  it { should allow_value(false).for(:is_public) }
  it { should_not allow_value(nil).for(:is_public) }

  it { should allow_value(true).for(:is_archived) }
  it { should allow_value(false).for(:is_archived) }
  it { should_not allow_value(nil).for(:is_archived) }

  it {is_expected.to validate_presence_of(:message_max_bytes_size)}


end
