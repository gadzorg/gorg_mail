# == Schema Information
#
# Table name: email_redirect_accounts
#
#  id                 :integer          not null, primary key
#  uid                :integer
#  redirect           :string(255)
#  rewrite            :string(255)
#  type_redir         :string(255)
#  action             :string(255)
#  broken_date        :date
#  broken_level       :integer
#  last               :date
#  flag               :string(255)
#  allow_rewrite      :integer
#  srs_rewrite        :string(255)
#  confirmation_token :string(255)
#  confirmed          :boolean          default(TRUE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#  broken_info        :string(255)
#
# Indexes
#
#  index_email_redirect_accounts_on_confirmation_token  (confirmation_token) UNIQUE
#  index_email_redirect_accounts_on_flag                (flag)
#  index_email_redirect_accounts_on_redirect            (redirect)
#  index_email_redirect_accounts_on_type_redir          (type_redir)
#  index_email_redirect_accounts_on_user_id             (user_id)
#

require "faker"

FactoryBot.define do
  factory :email_redirect_account do
    redirect { Faker::Internet.email }
    flag { "active" }
    type_redir { "smtp" }
  end
end
