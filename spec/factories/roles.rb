# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :role do
    name "admin"
    initialize_with { Role.find_or_create_by name:name}

    factory :distinct_role do
      initialize_with { Role.new}
    end


    factory :invalid_role do
      name nil
      initialize_with { Role.new}
    end

  end

end
