#  id                      :integer          not null, primary key
#  email                   :string(255)
#  redirect                :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  alias_type              :string(255)
#  email_virtual_domain_id :string(255)
#  expire                  :date
#  srs_rewrite             :integer
#  list_id                 :integer

FactoryGirl.define do
  factory :alias do

    email { Faker::Internet.user_name }
    redirect { Faker::Internet.email }
    email_virtual_domain_id 1

  end
end
