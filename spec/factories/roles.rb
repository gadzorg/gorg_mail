FactoryGirl.define do
  factory :role do
    name "admin"
    initialize_with { Role.find_or_create_by(name: name)}
  end

end
