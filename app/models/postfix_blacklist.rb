# == Schema Information
#
# Table name: postfix_blacklists
#
#  id          :integer          not null, primary key
#  email       :string
#  reject_text :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_postfix_blacklists_on_email  (email)
#

class PostfixBlacklist < ActiveRecord::Base
end
