# == Schema Information
#
# Table name: email_source_accounts
#
#  id                      :integer          not null, primary key
#  email                   :string(255)
#  uid                     :integer
#  type_source             :integer
#  flag                    :string(255)
#  expire                  :date
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :integer
#  email_virtual_domain_id :integer
#  primary                 :boolean
#
# Indexes
#
#  index_email_source_accounts_on_email                    (email)
#  index_email_source_accounts_on_email_virtual_domain_id  (email_virtual_domain_id)
#  index_email_source_accounts_on_flag                     (flag)
#  index_email_source_accounts_on_primary                  (primary)
#  index_email_source_accounts_on_user_id                  (user_id)
#

require "faker"

FactoryBot.define do
  factory :email_source_account do
    email { Faker::Internet.email.split("@").first }
    user
    primary { true }
    email_virtual_domain_id { 1 }
  end
end
