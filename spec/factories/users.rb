# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  hruid                  :string
#  firstname              :string
#  lastname               :string
#  role_id                :integer
#  last_gram_sync_at      :datetime
#

require "faker"

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    hruid do
      firstname.downcase.gsub(/[^a-z ]/, "") + "." +
        lastname.downcase.gsub(/[^a-z ]/, "") +
        "." +
        %w[1950 2015 ext soce associe].sample +
        ["", ".2", ".3"].sample
    end
    # canonical_name { firstname.downcase.gsub(/[^a-z ]/, '')+'.'+lastname.downcase.gsub(/[^a-z ]/, '')}
    password { Devise.friendly_token[0, 20] }
    password_confirmation { password }
    uuid { SecureRandom.uuid }

    factory :admin do
      association :role, name: "admin"
    end

    factory :support do
      association :role, name: "support"
    end

    factory :invalid_user do
      hruid { nil }
    end

    trait :non_gadz do
      is_gadz { false }
    end

    trait :gadz do
      is_gadz { true }
    end

    factory :user_with_addresses do
      transient { primary_email_source_account { nil } }

      after(:create) do |user, evaluator|
        esa_params = {
          user: user,
          primary: true,
          email:
            if evaluator.primary_email_source_account
              evaluator.primary_email_source_account.split("@").first
            else
              user.email.split("@").first
            end,
        }

        create(:email_source_account, esa_params)
        create(:email_redirect_account, user: user)
      end
    end

    factory :user_with_unconfirmed_googleapps do
      after(:create) do |user, evaluator|
        create(:email_source_account, user: user, primary: true)
        create(
          :email_redirect_account,
          user: user,
          type_redir: "googleapps",
          flag: "inactive",
          confirmed: false,
        )
      end
    end
  end
end
