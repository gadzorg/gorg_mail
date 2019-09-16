# == Schema Information
#
# Table name: postfix_blacklists
#
#  id          :integer          not null, primary key
#  email       :string(255)
#  reject_text :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  commentary  :string(255)
#
# Indexes
#
#  index_postfix_blacklists_on_email  (email)
#

class PostfixBlacklist < ApplicationRecord
end
