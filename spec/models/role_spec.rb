require 'rails_helper'

RSpec.describe Role, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:role)).to be_valid
  end

  it "is invalid if name already exist" do
    FactoryGirl.create(:distinct_role,name:'admin')
    expect(FactoryGirl.build(:distinct_role,name:'admin')).not_to be_valid
  end

end
