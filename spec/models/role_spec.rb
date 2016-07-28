# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Role, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:role)).to be_valid
  end

  it "is invalid if name already exist" do
    FactoryGirl.create(:distinct_role,name:'admin_test')
    expect(FactoryGirl.build(:distinct_role,name:'admin_test')).not_to be_valid
  end

end
