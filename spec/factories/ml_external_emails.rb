FactoryBot.define do
  factory :ml_external_email, class: "Ml::ExternalEmail" do
    ml_list
    email { Faker::Internet.email }
  end
end
