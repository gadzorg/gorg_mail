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
