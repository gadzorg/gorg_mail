require 'faker'

FactoryGirl.define do
  factory :email_redirect_account do
    redirect { Faker::Internet.email }

  end
end
